//
//  MappableTests.swift
//  MappableTests
//
//  Created by Leavez on 6/1/18.
//

import XCTest
@testable import Mappable


class ArrayModel: Mappable {
    let array : [Int]
    let arrayOfModel: [IntModel]

    required init(map: Mapper) throws {
        array = try map.from("array")
        arrayOfModel = try map.from("arrayOfModel")
    }
}


class MappableTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testArray() {
        let json = """
{
  "array": [1,2,3,4,5,6],
  "arrayOfModel": [{"int": 123}, {"int":456}]
}
"""
        let a = try? ArrayModel(JSONString: json)
        XCTAssertEqual([1,2,3,4,5,6], a?.array)
        XCTAssertEqual(a?.arrayOfModel[0].int, 123)
        XCTAssertEqual(a?.arrayOfModel[1].int, 456)
    }

    
}
