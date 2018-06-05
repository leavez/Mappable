//
//  MiscTest.swift
//  MappablePackageTests
//
//  Created by Gao on 6/5/18.
//

import XCTest
@testable import Mappable


class MiscTests: XCTestCase {


    func test_JSON_description() {
        let json = ["a": 1]
        _ = JSON(json).description
    }
    

    struct DirectlyCaseModel: Mappable {
        let a : [NSString]
        let b : Set<NSString>

        init(map: Mapper) throws {
            a = try map.from("a")
            b = try map.from("a")
        }
    }

    func test_directly_cast() {
        let json: [String: Any] = ["a": ["1","2","3"]]
        XCTAssertEqual(try? DirectlyCaseModel(JSONObject: json).a, ["1","2","3"])
        XCTAssertEqual(try? DirectlyCaseModel(JSONObject: json).b, Set(["1","2","3"]))
    }

    func test_getRawValue() {
        let json: [String: Any] = ["a": ["1","2","3"]]
        XCTAssertEqual(JSON(json).getRootValue() as? [String:[String]], ["a": ["1","2","3"]])
        XCTAssertEqual(JSON(json).getValue("a") as? [String], ["1","2","3"])
    }


}
