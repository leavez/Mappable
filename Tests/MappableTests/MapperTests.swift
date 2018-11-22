//
//  MapperTests.swift
//  MappableTests
//
//  Created by leave on 2018/11/22.
//

import XCTest
@testable import Mappable

class MapperTests: XCTestCase {

    static let json: [String: Any] = [
        "a": [
            "str": "aa",
            "int": 3,
            "array": ["1", 2, "3"],
            "dict": [
                "a": 1,
                "b": "123123"
            ]
        ],
        "b" : "hello world",
        "c" : 12.4
    ]
    let mapper = JSONMapper(JSON: json)
    
    struct Inner: Mappable {
        let a: String
        let b: String
        
        init(map: Mapper) throws {
            a = try map.a()
            b = try map.b()
        }
    }

    
    func test_from() {
        let value: String = try! mapper.from("b")
        XCTAssertEqual(value, "hello world")
        let value2: Inner = try! mapper.from("a.dict")
        XCTAssertEqual(value2.a, "1")
        XCTAssertEqual(value2.b, "123123")
    }
    
    func test_dynamicMemberLookup() {
        let value: String = try! mapper.b()
        XCTAssertEqual(value, "hello world")
        let value2: Double = try! mapper.c()
        XCTAssertEqual(value2, 12.4)
    }
    
    func test_getValue() {
        // get root value
        let rootValue: [String: Any] = mapper.getRootValue() as! [String:Any]
        XCTAssertEqual(rootValue["b"] as! String, "hello world")
        
        // get keypath
        let value = mapper.getValue("a.dict.a") as! Int
        XCTAssertEqual(value, 1)
    }
    
    func test_subMapper() {
        guard let sub = mapper.subMapper(keyPath: "a.dict") else {
            XCTFail()
            return
        }
        let value = try! Inner(map: sub)
        XCTAssertEqual(value.b, "123123")
    }

}

