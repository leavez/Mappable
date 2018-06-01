//
//  BaseTest.swift
//  MappableTests
//
//  Created by Leavez on 6/1/18.
//

import XCTest
@testable import Mappable

class IntModel: Mappable, Hashable {
    let int: Int
    required init(map: Mapper) throws {
        int = try map.from("int")
    }
    init(_ int: Int) {
        self.int = int
    }
    var hashValue: Int {
        return int
    }
    static func ==(lhs: IntModel, rhs:IntModel) -> Bool {
        return lhs.int == rhs.int
    }
}


class BaseTest: XCTestCase {

    func testInt() {
        let json = """
{
    "int": 123
}
"""
        let a = try? IntModel(JSONString: json)
        XCTAssertEqual(a?.int, 123)
    }

}
