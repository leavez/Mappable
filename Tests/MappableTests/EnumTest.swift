//
//  EnumTest.swift
//  MappableTests
//
//  Created by Leavez on 6/1/18.
//

import XCTest
@testable import Mappable

enum EnumModel:Int, Mappable {
    case A, B, C
}

struct EnumArrayModel: Mappable {
    let array: [EnumModel]
    init(map: Mapper) throws {
        array = try map.from("values")
    }
}


enum EnumWithValueModel: Mappable, Equatable {
    case a(Int)
    case b(String)
    
    init(map: Mapper) throws {
        let value = try map.getValue("type", as: String.self)
        switch value {
        case "a":
            self = .a(try map.from("value"))
        case "b":
            self = .b(try map.from("value"))
        default:
            throw ErrorType.JSONStructureNotMatchDesired(value, "string a/b")
        }
    }
    
    static func == (lhs: EnumWithValueModel, rhs: EnumWithValueModel) -> Bool {
        switch (lhs, rhs) {
        case (.a(let a1), .a(let a2)):
            return a1 == a2
        case (.b(let a1), .b(let a2)):
            return a1 == a2
        default:
            return false
        }
    }
}

class EnumTests: XCTestCase {

    func test() {
        let json = """
{
    "values": [0,1,2]
}
"""
        do {
            let a = try EnumArrayModel(JSONString: json)
            XCTAssertEqual(a.array[0], EnumModel.A)
            XCTAssertEqual(a.array[1], EnumModel.B)
            XCTAssertEqual(a.array[2], EnumModel.C)
        } catch let e {
            XCTFail(e.localizedDescription)
        }
    }
    
    func testCustomConversion() {
        
        let json = """
        [
            {"type": "a", "value": 123},
            {"type": "a", "value": 0},
            {"type": "b", "value": "hello"},
            {"type": "b", "value": "world"},
        ]
        """
        do {
            let a = try [EnumWithValueModel](JSONString: json)
            XCTAssertEqual(a[0], EnumWithValueModel.a(123))
            XCTAssertEqual(a[1], EnumWithValueModel.a(0))
            XCTAssertEqual(a[2], EnumWithValueModel.b("hello"))
            XCTAssertEqual(a[3], EnumWithValueModel.b("world"))

        } catch let e {
            XCTFail(e.localizedDescription)
        }
        
        let json2 = """
        [
            {"type": 123, "value": 123},
            {"type": {}, "value": 0},
        ]
        """
        XCTAssertThrowsError(try [EnumWithValueModel](JSONString: json2))
    }
}
