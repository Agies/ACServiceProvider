//
//  ACServiceProvider.swift
//  ACServiceProvider
//
//  Created by agies on 4/5/16.
//  Copyright © 2016 alliancedata. All rights reserved.
//

import Foundation

public class ACServiceProvider: NSObject {
    typealias ACProviderFactory = (ACServiceProvider) -> Any
    var container = [String: ACProviderFactory]()
    public func registerInstance<T>(obj:T) -> ACServiceProvider {
        registerInstanceOf(T.self, obj: obj)
        return self
    }
    public func registerType<T>(factory: (ACServiceProvider) -> T) -> ACRegistrationContext<T> {
        let key = createKey(T)
        container[key] = factory
        return ACRegistrationContext<T>(key: key, factory: factory, provider: self)
    }
    public func registerInstanceOf<T>(type: T.Type, obj: T) -> ACServiceProvider  {
        let factory : (ACServiceProvider) -> Any = { _ in obj }
        container[createKey(type)] = factory
        return self
    }
    public func getInstanceOf<T>(type: T.Type) -> T? {
        return container[createKey(type)]?(self) as? T
    }
    public func getInstance<T>() -> T? {
        return getInstanceOf(T)
    }
    private func createKey(type: Any.Type) -> String {
        return String(type)
    }
}

public struct ACRegistrationContext<T> {
    let provider: ACServiceProvider
    let key: String
    let factory: (ACServiceProvider) -> T
    init(key: String, factory: (ACServiceProvider) -> T, provider: ACServiceProvider) {
        self.key = key
        self.factory = factory
        self.provider = provider
    }
    public func singleton() -> ACServiceProvider {
        provider.container[key] = { p in
            let result = self.factory(p)
            p.container[self.key] = { _ in
                return result
            }
            return result
        }
        return self.provider
    }
    public func transient() -> ACServiceProvider {
        return self.provider
    }
}
