//
//  BasicTypeTest.swift
//  MappableTests
//
//  Created by Leavez on 6/1/18.
//

import XCTest
@testable import Mappable

class IntTypesModel: Mappable {

    let int: Int
    let int8: Int8
    let int16: Int16
    let int32: Int32
    let int64: Int64
    let uInt: UInt
    let uInt8: UInt8
    let uInt16: UInt16
    let uInt32: UInt32
    let uInt64: UInt64

    required init(map: Mapper) throws {
        int = try map.from("int")
        int8 = try map.from("short")
        int16 = try map.from("int")
        int32 = try map.from("int")
        int64 = try map.from("long")
        uInt = try map.from("uint")
        uInt8 = try map.from("short")
        uInt16 = try map.from("uint")
        uInt32 = try map.from("uint")
        uInt64 = try map.from("long")
    }
}

class BasicTypesTest: XCTestCase {

    func testInt() {
        let json = """
{
    "short": 123,
    "int": 12345,
    "uint": 12345,
    "long": 1234567891011121314
}
"""
        do{
            let a = try IntTypesModel(JSONString: json)
            XCTAssertEqual(a.int, 12345)
            XCTAssertEqual(a.int8, 123)
            XCTAssertEqual(a.int16, 12345)
            XCTAssertEqual(a.int32, 12345)
            XCTAssertEqual(a.int64, 1234567891011121314)
            XCTAssertEqual(a.uInt, 12345)
            XCTAssertEqual(a.uInt8, 123)
            XCTAssertEqual(a.uInt16, 12345)
            XCTAssertEqual(a.uInt32, 12345)
            XCTAssertEqual(a.uInt64, 1234567891011121314)
        } catch let e {
            print(e)
            XCTAssertTrue(false)
        }

        let json2 = """
{
    "short": "123",
    "int": "-12345",
    "uint": "12345",
    "long": "1234567891011121314"
}
"""
        do{
            let a = try IntTypesModel(JSONString: json2)
            XCTAssertEqual(a.int, -12345)
            XCTAssertEqual(a.int8, 123)
            XCTAssertEqual(a.int16, -12345)
            XCTAssertEqual(a.int32, -12345)
            XCTAssertEqual(a.int64, 1234567891011121314)
            XCTAssertEqual(a.uInt, 12345)
            XCTAssertEqual(a.uInt8, 123)
            XCTAssertEqual(a.uInt16, 12345)
            XCTAssertEqual(a.uInt32, 12345)
            XCTAssertEqual(a.uInt64, 1234567891011121314)
        } catch let e {
            print(e)
            XCTAssertTrue(false)
        }
    }


}
