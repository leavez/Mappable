//
//  BasicTypeTest.swift
//  MappableTests
//
//  Created by Leavez on 6/1/18.
//

import XCTest
@testable import Mappable
#if canImport(CoreGraphics)
import CoreGraphics
#endif


class BasicTypesTest: XCTestCase {

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
            XCTFail(e.localizedDescription)
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
            XCTFail(e.localizedDescription)
        }
        XCTAssertEqual(try? Int(JSONString: "1.1") , 1)

    }
    

    struct IntTypeModel2: Mappable {
        let int: Int
        
        init(map: Mapper) throws {
            int = try map.from("int")
        }
    }
    
    func testInt2() {
        [Int.min, -999999, -1, 0, 1, 100, 99999999, Int.max].forEach { value in
            XCTAssertEqual(try? IntTypeModel2(JSONObject: ["int": value]).int, value)
            XCTAssertEqual(try? IntTypeModel2(JSONObject: ["int": String(value)]).int, value)
        }
        XCTAssertEqual(try? IntTypeModel2(JSONObject: ["int": 0x123]).int, 0x123)
        XCTAssertThrowsError(try IntTypeModel2(JSONObject: ["int": "1.0"]))
    }
    
    
    
    
    class FloatTypesModel: Mappable {
        
        let double: Double
        let float: Float
        #if canImport(CoreGraphics)
        let cgFloat: CGFloat
        #endif
        
        required init(map: Mapper) throws {
            double = try map.from("double")
            float = try map.from("double")
            #if canImport(CoreGraphics)
            cgFloat = try map.from("double")
            #endif
        }
    }

    func testFloat() {
        do{
            let a = try FloatTypesModel(JSONObject: ["double": "-12345.123"])
            XCTAssertEqual(a.double, -12345.123)
            XCTAssertEqual(a.float, -12345.123)
            #if canImport(CoreGraphics)
            XCTAssertEqual(a.cgFloat, -12345.123)
            #endif
        } catch let e {
            XCTFail(e.localizedDescription)
        }
        
        XCTAssertEqual(try? FloatTypesModel(JSONObject: ["double": 1]).double, 1)
        XCTAssertEqual(try? FloatTypesModel(JSONObject: ["double": 1.0]).double, 1)
        XCTAssertEqual(try? FloatTypesModel(JSONObject: ["double": 1.01]).double, 1.01)
        XCTAssertEqual(try? FloatTypesModel(JSONObject: ["double": "1.01"]).double, 1.01)
        XCTAssertEqual(try? FloatTypesModel(JSONObject: ["double": "-1.01"]).double, -1.01)
        XCTAssertEqual(try? FloatTypesModel(JSONObject: ["double": "0"]).double, 0)
        XCTAssertThrowsError(try FloatTypesModel(JSONObject: ["double": "aaa"]))
    }
    
    
    
    
    struct BoolModel: Mappable {
        let bool: Bool
        
        init(map: Mapper) throws {
            bool = try map.from("bool")
        }
    }
    
    func testBool() {
        XCTAssertEqual(try? BoolModel(JSONObject: ["bool": 0]).bool, false)
        XCTAssertEqual(try? BoolModel(JSONObject: ["bool": -1]).bool, true)
        XCTAssertEqual(try? BoolModel(JSONObject: ["bool": 1]).bool, true)
        XCTAssertEqual(try? BoolModel(JSONObject: ["bool": 9999]).bool, true)
        XCTAssertEqual(try? BoolModel(JSONObject: ["bool": "YES"]).bool, true)
        XCTAssertEqual(try? BoolModel(JSONObject: ["bool": "True"]).bool, true)
        XCTAssertEqual(try? BoolModel(JSONObject: ["bool": "true"]).bool, true)
        XCTAssertEqual(try? BoolModel(JSONObject: ["bool": "TRUE"]).bool, true)
        XCTAssertEqual(try? BoolModel(JSONObject: ["bool": "1"]).bool, true)
        XCTAssertEqual(try? BoolModel(JSONObject: ["bool": "NO"]).bool, false)
        XCTAssertEqual(try? BoolModel(JSONObject: ["bool": "False"]).bool, false)
        XCTAssertEqual(try? BoolModel(JSONObject: ["bool": "FALSE"]).bool, false)
        XCTAssertEqual(try? BoolModel(JSONObject: ["bool": "false"]).bool, false)
        XCTAssertEqual(try? BoolModel(JSONObject: ["bool": "0"]).bool, false)

        XCTAssertThrowsError(try BoolModel(JSONObject: ["bool": "aaa"]).bool)
        XCTAssertThrowsError(try BoolModel(JSONObject: ["bool": 12.34]).bool)
        XCTAssertThrowsError(try BoolModel(JSONObject: ["bool": "2"]).bool)
    }
    
    
    
    struct StringModel: Mappable {
        let value: String
        
        init(map: Mapper) throws {
            value = try map.from("value")
        }
    }
    
    func testString() {
        XCTAssertEqual(try? StringModel(JSONObject: ["value": "ssss"]).value, "ssss")
        XCTAssertEqual(try? StringModel(JSONObject: ["value": 0]).value, "0")
        XCTAssertEqual(try? StringModel(JSONObject: ["value": 123]).value, "123")
        XCTAssertEqual(try? StringModel(JSONObject: ["value": -1]).value, "-1")
        XCTAssertEqual(try? StringModel(JSONObject: ["value": 123.0]).value, "123")
        XCTAssertEqual(try? StringModel(JSONObject: ["value": 123.456]).value, "123.456")
        XCTAssertEqual(try? StringModel(JSONObject: ["value": -123.456]).value, "-123.456")
        
        XCTAssertThrowsError(try StringModel(JSONObject: ["value": []]).value)
        XCTAssertThrowsError(try StringModel(JSONObject: ["value": [:]]).value)
    }

    struct UrlModel: Mappable {
        let value: URL
        init(map: Mapper) throws {
            value = try map.from("value")
        }
    }
    
    func testURL() {
        XCTAssertEqual(try? UrlModel(JSONObject: ["value": "/a/b"]).value, URL(string: "/a/b"))
        XCTAssertThrowsError(try UrlModel(JSONObject: ["value": 123]).value)
    }
    
    
    struct DateModel: Mappable {
        let value: Date
        init(map: Mapper) throws {
            value = try map.from("value")
        }
    }
    struct DateModel2: Mappable {
        let value: Date
        init(map: Mapper) throws {
            map.options.dateDecodingStrategy = .millisecondsSince1970
            value = try map.from("value")
        }
    }
    struct DateModel3: Mappable {
        let value: Date
        init(map: Mapper) throws {
            map.options.dateDecodingStrategy = .iso8601InRFC3339Format
            value = try map.from("value")
        }
    }
    struct DateModel4: Mappable {
        let value: Date
        init(map: Mapper) throws {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyyMMdd"
            map.options.dateDecodingStrategy = .formatted(formatter)
            value = try map.from("value")
        }
    }
    struct DateModelNest: Mappable {
        let value: Date
        let nested: DateModel
        let nested2: DateModel2
        init(map: Mapper) throws {
            map.options.dateDecodingStrategy = .secondsSince1970
            value = try map.from("value")
            nested = try map.from("nested")
            nested2 = try map.from("nested2")
        }
    }
    
    func testDate() {
        XCTAssertEqual(try? DateModel(JSONObject: ["value": "2018-06-03T13:11:50+08:00"]).value, Date(timeIntervalSince1970: 1528002710))
        XCTAssertEqual(try? DateModel(JSONObject: ["value": 1528002710]).value, Date(timeIntervalSince1970: 1528002710))
        XCTAssertEqual(try? DateModel(JSONObject: ["value": 1528002710.123456]).value, Date(timeIntervalSince1970: 1528002710.123456))
        XCTAssertThrowsError(try DateModel(JSONObject: ["value": "123123123"]))
    }
    
    func testDateStrategy() {
        XCTAssertEqual(try? DateModel2(JSONObject: ["value": 1528002710123.456]).value, Date(timeIntervalSince1970: 1528002710.123456))
        XCTAssertThrowsError(try DateModel2(JSONObject: ["value": "2018-06-03T13:11:50+08:00"]))

        XCTAssertEqual(try? DateModel3(JSONObject: ["value": "2018-06-03T13:11:50+08:00"]).value, Date(timeIntervalSince1970: 1528002710))
        XCTAssertThrowsError(try DateModel3(JSONObject: ["value": 1528002710.123456]))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let date = formatter.date(from: "20180615")
        XCTAssertEqual(try? DateModel4(JSONObject: ["value": "20180615"]).value, date)
        XCTAssertThrowsError(try DateModel4(JSONObject: ["value": 1528002710.123456]))
        XCTAssertThrowsError(try DateModel4(JSONObject: ["value": "2018-06-03T13:11:50+08:00"]))
    }
    
    func testDateStrategyInheritance() {
        let json: [String : Any] = [
            "value": 1528002710.123456,
            "nested": [ "value": 1528002710.123456, ],
            "nested2": [ "value": 1528002710123.456, ],
            ]
        let nest = try? DateModelNest(JSONObject:json)
        XCTAssertEqual(nest?.value, Date(timeIntervalSince1970: 1528002710.123456))
        XCTAssertEqual(nest?.nested.value, Date(timeIntervalSince1970: 1528002710.123456))
        XCTAssertEqual(nest?.nested2.value, Date(timeIntervalSince1970: 1528002710.123456))
    }

}
