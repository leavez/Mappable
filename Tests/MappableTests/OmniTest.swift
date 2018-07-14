//
//  OmniTest.swift
//  MappableTests
//
//  Created by Leavez on 6/1/18.
//

import Foundation

import XCTest
@testable import Mappable


class OmniModel: Mappable, Equatable {
    let a = 1
    let optional: OmniModel?
    let array: [OmniModel]
    let optionalArray: [OmniModel?]
    let dict: [String: OmniModel]

    required init(map: Mapper) throws {
        optional = try map.from("optional")
        array = try map.from("array")
        optionalArray = try map.from("optionalArray")
        dict = try map.from("dict")
    }

    static func == (lhs: OmniModel, rhs: OmniModel) -> Bool {
        return lhs.optional == rhs.optional &&
            lhs.array == rhs.array &&
            lhs.optionalArray == rhs.optionalArray &&
            lhs.dict == rhs.dict
    }
}

class OmniModel2: Mappable, Equatable {
    let direct: NSString
    let optional: OmniModel2?
    let array: [OmniModel2]
    let optionalArray: [OmniModel2?]
    let dict: [String: OmniModel2]
    
    required init(map: Mapper) throws {
        direct = try map.aaa()
        optional = try map.optional()
        array = try map.array()
        optionalArray = try map.optionalArray()
        dict = try map.dict()
    }
    
    static func == (lhs: OmniModel2, rhs: OmniModel2) -> Bool {
        return lhs.optional == rhs.optional &&
            lhs.array == rhs.array &&
            lhs.optionalArray == rhs.optionalArray &&
            lhs.dict == rhs.dict
    }
}

class OmniTests: XCTestCase {

    let outerJson: [String:Any] = {
        let aJson: [String: Any] = [
            "optional":"should be nil",
            "array": [],
            "optionalArray": ["should be nil"],
            "dict": [:],
            "aaa" : "Plain String",
        ]
        return [
            "aaa" : "Plain String",
            "optional": aJson,
            "array": [aJson, aJson],
            "optionalArray": [aJson],
            "dict": ["1": aJson, "2": aJson]
        ]
    }()
    
    func test() {
        do {
            let a = try OmniModel(JSONObject: outerJson)
            XCTAssertEqual(a.optional?.optional, nil)
            XCTAssertEqual(a.array[0], a.optional)
            XCTAssertEqual(a.array[1], a.array[0])
            XCTAssertEqual(a.optionalArray[0]?.optionalArray, [nil])
            XCTAssertEqual(a.dict["1"], a.optional)
        } catch let e {
            XCTFail(e.localizedDescription)
        }
    }
    
    func testDynamicMemberLookUpAPI() {
        do {
            let a = try OmniModel2(JSONObject: outerJson)
            XCTAssertEqual(a.optional?.optional, nil)
            XCTAssertEqual(a.array[0], a.optional)
            XCTAssertEqual(a.array[1], a.array[0])
            XCTAssertEqual(a.optionalArray[0]?.optionalArray, [nil])
            XCTAssertEqual(a.dict["1"], a.optional)
        } catch let e {
            XCTFail(e.localizedDescription)
        }
    }
}
