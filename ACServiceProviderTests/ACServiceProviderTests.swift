//
//  ACServiceProviderTests.swift
//  ACServiceProviderTests
//
//  Created by agies on 4/5/16.
//  Copyright © 2016 alliancedata. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import ACServiceProvider

class ACServiceProviderTests: QuickSpec {
    override func spec() {
        describe("When registering an entity") {
            var subject: ACServiceProvider!
            beforeEach {
                subject = ACServiceProvider()
            }
            it("should allow a standard registration") {
                let expected = NSObject()
                let actual = subject
                    .registerInstance(expected)
                    .getInstanceOf(NSObject.self)
                expect(actual).to(beIdenticalTo(expected))
            }
            it("should get a typed instance") {
                let expected = NSObject()
                let actual: NSObject? = subject
                    .registerInstance(expected)
                    .getInstance()
                expect(actual).to(beIdenticalTo(expected))
            }
            it("should allow a inherited registration") {
                let expected: AnyObject = NSObject()
                subject.registerInstance(expected)
                let key = String(AnyObject.self)
                let factory = subject.container[key]
                expect(factory?(subject) as? AnyObject).to(beIdenticalTo(expected))
            }
            it("should allow a specified registration") {
                let expected = NSObject()
                subject.registerInstanceOf(AnyObject.self, obj: expected)
                let key = String(AnyObject.self)
                let factory = subject.container[key]
                expect(factory?(subject) as? AnyObject).to(beIdenticalTo(expected))
            }
            it("should allow a standard registration by type") {
                let expected = "Blah"
                subject.registerInstanceOf(AnyObject.self, obj: expected)
                let key = String(AnyObject.self)
                let factory = subject.container[key]
                expect(factory?(subject) as? String).to(equal(expected))
            }
            it("should allow a factory to be registered for a type") {
                let expected = NSObject()
                subject.registerType({ (provider) -> NSObject in
                    return expected
                })
                let key = String(NSObject.self)
                let factory = subject.container[key]
                expect(factory?(subject) as? NSObject).to(equal(expected))
            }
            it("should allow a factory to be transient by default") {
                subject.registerType({ (provider) -> NSObject in
                    return NSObject()
                })
                let expected = subject.getInstanceOf(NSObject.self)
                let actual = subject.getInstanceOf(NSObject.self)
                expect(actual).toNot(beNil())
                expect(actual).toNot(equal(expected))
            }
            it("should allow a factory to be a singleton if set") {
                subject.registerType({ (provider) -> NSObject in
                    return NSObject()
                }).singleton()
                let expected = subject.getInstanceOf(NSObject.self)
                let actual = subject.getInstanceOf(NSObject.self)
                expect(actual).toNot(beNil())
                expect(actual).to(equal(expected))
            }
        }
    }
}