//
//  OptionalTest.swift
//  MappableTests
//
//  Created by Leavez on 6/1/18.
//

import XCTest
@testable import Mappable

class OptionalIntModel: Mappable {
    let int: Int?
    let int2: Int?
    let model: IntModel?
    let model2: IntModel?

    required init(map: Mapper) throws {
        int = try map.from("int")
        int2 = try map.from("int2")
        model = try map.from("model")
        model2 = try map.from("model2")
    }
}

class OptionalTests: XCTestCase {

    func test() {
        let json = """
{
        "int": 1,
        "int2": {},
        "int3": null,
        "model": {"int": 123},
        "model2": "ddddd"
}
"""
        do {
            let a = try OptionalIntModel(JSONString: json)
            XCTAssertEqual(a.int, 1)
            XCTAssertEqual(a.int2, nil)
            XCTAssertEqual(a.model?.int, 123)
            XCTAssertTrue(a.model2 == nil)
        } catch let e {
            print(e)
            XCTAssertTrue(false)
        }
    }
}
