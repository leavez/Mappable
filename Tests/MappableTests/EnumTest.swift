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
            print(e)
            XCTAssertTrue(false)
        }
    }
}
