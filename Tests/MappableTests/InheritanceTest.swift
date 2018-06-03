//
//  InheretanceTest.swift
//  MappablePackageTests
//
//  Created by Gao on 2018/6/1.
//

import XCTest
@testable import Mappable


class InheritanceModel: IntModel {
    let b : Int
    required init(map: Mapper) throws {
        b = try map.from("b")
        try super.init(map: map)
    }
}

class InheritanceTests: XCTestCase {
    
    func test() {
        let json = """
{
    "int": 123,
    "b": 456
}
"""
        do {
            let a = try InheritanceModel(JSONString: json)
            XCTAssertEqual(a.int, 123)
            XCTAssertEqual(a.b, 456)
        } catch let e {
            XCTFail(e.localizedDescription)
        }
    }
}
