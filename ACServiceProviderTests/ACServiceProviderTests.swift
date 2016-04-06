//
//  ACServiceProviderTests.swift
//  ACServiceProviderTests
//
//  Created by agies on 4/5/16.
//  Copyright © 2016 alliancedata. All rights reserved.
//

import XCTest
@testable import ACServiceProvider

class ACServiceProviderTests: XCTestCase {
    var subject: ACServiceProvider!
    override func setUp() {
        subject = ACServiceProvider()
    }
    func testItShould_allow_a_standard_registration() {
        let expected = NSObject()
        let actual = subject
            .registerInstance(expected)
            .getInstanceOf(NSObject.self)
        XCTAssertEqual(actual, expected)
    }
    func testIt_should_get_a_typed_instance() {
        let expected = NSObject()
        let actual: NSObject? = subject
            .registerInstance(expected)
            .getInstance()
        XCTAssertEqual(actual, expected)
    }
    func testIt_should_allow_a_inherited_registration() {
        let expected: AnyObject = NSObject()
        subject.registerInstance(expected)
        let key = String(AnyObject.self)
        let factory = subject.container[key]
        XCTAssertEqual(factory?(subject) as? NSObject, expected as? NSObject)
    }
    func testIt_should_allow_a_specified_registration() {
        let expected = NSObject()
        subject.registerInstanceOf(AnyObject.self, obj: expected)
        let key = String(AnyObject.self)
        let factory = subject.container[key]
        XCTAssertEqual(factory?(subject) as? NSObject, expected)
    }
    func testIt_should_allow_a_standard_registration_by_type() {
        let expected = "Blah"
        subject.registerInstanceOf(AnyObject.self, obj: expected)
        let key = String(AnyObject.self)
        let factory = subject.container[key]
        XCTAssertEqual(factory?(subject) as? NSObject, expected)
    }
    func testIt_should_allow_a_factory_to_be_registered_for_a_type() {
        let expected = NSObject()
        subject.registerType({ (provider) -> NSObject in
            return expected
        })
        let key = String(NSObject.self)
        let factory = subject.container[key]
        XCTAssertEqual(factory?(subject) as? NSObject, expected)
    }
    func testIt_should_allow_a_factory_to_be_transient_by_default() {
        subject.registerType({ (provider) -> NSObject in
            return NSObject()
        })
        let expected = subject.getInstanceOf(NSObject.self)
        let actual = subject.getInstanceOf(NSObject.self)
        XCTAssertNotNil(actual)
        XCTAssertNotEqual(actual, expected)
    }
    func testIt_should_allow_a_factory_to_be_a_singleton_if_set() {
        subject.registerType({ (provider) -> NSObject in
            return NSObject()
        }).singleton()
        let expected = subject.getInstanceOf(NSObject.self)
        let actual = subject.getInstanceOf(NSObject.self)
        XCTAssertNotNil(actual)
        XCTAssertEqual(actual, expected)
    }
}