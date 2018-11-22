//
//  DefaultValueTest.swift
//  Mappable
//
//  Created by Leavez on 2018/6/12.
//

import XCTest
@testable import Mappable

class DefaultValueModel: Mappable {
    let int: Int
    let model: IntModel
    required init(map: Mapper) throws {
        int = try map.from("int") ?? 123
        model = try map.from("a") ?? IntModel(JSONObject: ["int": 444])
    }
}


class DefaultValueTest: XCTestCase {
    
    func test() {
        let json = """
{
    "int": []
}
"""
        let a = try! DefaultValueModel(JSONString: json)
        XCTAssertEqual(a.int, 123)
        XCTAssertEqual(a.model.int, 444)
    }
    
}
