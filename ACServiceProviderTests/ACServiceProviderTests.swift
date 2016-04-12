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
    //MARK -> Registrations
    func testItShould_allow_a_standard_registration() {
        let expected = NSObject()
        let actual = subject
            .registerInstance(expected)
            .getInstanceOf(NSObject.self)
        XCTAssertEqual(actual, expected)
    }
    func testRegistrationByNameShouldCreateASeperateRegistration() {
        let other = NSObject()
        let expected = NSObject()
        subject.registerInstance(expected, name: "Mine")
        subject.registerInstance(other)
        let actual: NSObject? = subject
            .getInstance("Mine")
        XCTAssertEqual(actual, expected)
    }
    func testSameRegistrationsOverwriteEachOther() {
        let other = NSObject()
        let expected = NSObject()
        subject.registerInstance(other)
        subject.registerInstance(expected)
        let actual: NSObject? = subject
            .getInstance()
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
        let actual = subject.getInstanceOf(AnyObject)
        XCTAssertEqual(actual as? NSObject, expected as? NSObject)
    }
    func testIt_should_allow_a_specified_registration() {
        let expected = NSObject()
        subject.registerInstanceOf(AnyObject.self, obj: expected)
        let actual = subject.getInstanceOf(AnyObject)
        XCTAssertEqual(actual as? NSObject, expected)
    }
    func testIt_should_allow_a_standard_registration_by_type() {
        let expected = "Blah"
        subject.registerInstanceOf(AnyObject.self, obj: expected)
        let actual = subject.getInstanceOf(AnyObject)
        XCTAssertEqual(actual  as? String, expected)
    }
    func testIt_should_allow_a_factory_to_be_registered_for_a_type() {
        let expected = NSObject()
        subject.registerType({ (provider) -> NSObject in
            return expected
        })
        let actual: NSObject? = subject.getInstance()
        XCTAssertEqual(actual, expected)
    }
    //MARK -> Gets
    func testItShouldGetAllRegisteredForATypeIfRegisteredByName() {
        subject.registerInstance("1", name: "0")
        subject.registerInstanceOf(String.self, obj: "2", name: "1")
        subject.registerType("2", factory: { (p) -> String in
            "3"
        })
        let getAll: [String] = subject.getAll()
        XCTAssertEqual(getAll.count, 3)
        XCTAssertEqual(subject.getInstanceOf(String.self, name: "0"), "1")
        XCTAssertEqual(subject.getInstanceOf(String.self, name: "1"), "2")
        XCTAssertEqual(subject.getInstanceOf(String.self, name: "2"), "3")
        XCTAssertTrue(getAll.contains("1"))
        XCTAssertTrue(getAll.contains("2"))
        XCTAssertTrue(getAll.contains("3"))
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
    func testIt_should_allow_a_factory_to_be_a_singleton_if_set_multiple() {
        subject.registerType({ (provider) -> NSObject in
            return NSObject()
        }).singleton()
        subject.registerType("blah", factory: { (provider) -> NSObject in
            return NSObject()
        }).singleton()
        let expected = subject.getInstanceOf(NSObject.self)
        let actual = subject.getInstanceOf(NSObject.self)
        XCTAssertNotNil(actual)
        XCTAssertEqual(actual, expected)
        XCTAssertEqual(subject.getInstanceOf(NSObject.self, name: "blah"), subject.getInstanceOf(NSObject.self, name: "blah"))
        XCTAssertNotEqual(subject.getInstanceOf(NSObject.self, name: "blah"), subject.getInstanceOf(NSObject.self))
    }
}