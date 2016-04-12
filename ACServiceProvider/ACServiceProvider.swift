//
//  ACServiceProvider.swift
//  ACServiceProvider
//
//  Created by agies on 4/5/16.
//  Copyright © 2016 alliancedata. All rights reserved.
//

import Foundation

internal typealias ACProviderFactory = (ACServiceProvider) -> Any

public class ACServiceProvider: NSObject {
    var container = [String: [String: ACProviderFactory]]()
    public func registerInstance<T>(obj:T, name: String = "") -> ACServiceProvider {
        registerInstanceOf(T.self, obj: obj, name: name)
        return self
    }
    public func registerType<T>(factory: (ACServiceProvider) -> T) -> ACRegistrationContext<T> {
        return registerType("", factory: factory)
    }
    public func registerType<T>(name: String = "", factory: (ACServiceProvider) -> T) -> ACRegistrationContext<T> {
        appendToContainerFor(ACServiceProvider.createKey(T), name: name, factory: factory)
        return ACRegistrationContext<T>(name: name, factory: factory, provider: self)
    }
    public func registerInstanceOf<T>(type: T.Type, obj: T, name: String = "") -> ACServiceProvider  {
        let factory : (ACServiceProvider) -> Any = { _ in obj }
        appendToContainerFor(ACServiceProvider.createKey(T), name: name, factory: factory)
        return self
    }
    public func getInstanceOf<T>(type: T.Type, name: String = "") -> T? {
        return container[ACServiceProvider.createKey(type)]?[name]?(self) as? T
    }
    public func getInstance<T>(name: String = "") -> T? {
        return getInstanceOf(T.self, name: name)
    }
    public func getAll<T>() -> [T] {
        var mappedResult = [T]()
        if let con = container[ACServiceProvider.createKey(T)] {
            for item in  con {
                if let result = (item.1(self) as? T) {
                    mappedResult.append(result)
                }
            }
        }
        return mappedResult
    }
    private func appendToContainerFor(key: String, name: String, factory: ACProviderFactory) -> Int {
        if container[key] == nil {
            container[key] = [:]
        }
        let index = container[key]!.count
        container[key]![name] = factory
        return index
    }
    private class func createKey(type: Any.Type) -> String {
        return String(type)
    }
}

public struct ACRegistrationContext<T> {
    let provider: ACServiceProvider
    let name: String
    let factory: (ACServiceProvider) -> T
    init(name: String, factory: (ACServiceProvider) -> T, provider: ACServiceProvider) {
        self.name = name
        self.factory = factory
        self.provider = provider
    }
    public func singleton() -> ACServiceProvider {
        let key = ACServiceProvider.createKey(T)
        let factory: ACProviderFactory = { p in
            let result = self.factory(p)
            p.container[key] = [self.name: { _ in
                return result
                }]
            return result
        }
        provider.appendToContainerFor(key, name: name, factory: factory)
        return self.provider
    }
    public func transient() -> ACServiceProvider {
        return self.provider
    }
}
