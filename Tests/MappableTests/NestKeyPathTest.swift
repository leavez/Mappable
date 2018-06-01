//
//  NestKeyPathTest.swift
//  MappableTests
//
//  Created by Leavez on 6/1/18.
//

import XCTest
@testable import Mappable


struct NestedKeyPathModel: Mappable {
    let array: [EnumModel]
    let enu: EnumModel
    let enu2: EnumModel
    let enu3: EnumModel

    init(map: Mapper) throws {
        array = try map.from("values.AA")
        enu = try map.from("values.AA.`1`")
        enu2 = try map.from("AA.`0`.BB.`0`.CC")
        enu3 = try map.from("values.AA", keyPathIsNested: false)
    }
}

class NestedKeyPathTests: XCTestCase {

    func test() {
        let json = """
{
    "values.AA": 2,
    "values": {
        "AA": [0,1,2]
    },
    "AA": [
       {
         "BB": [
            {"CC": 0}
          ]
       }
    ]
}
"""
        do {
            let a = try NestedKeyPathModel(JSONString: json)
            XCTAssertEqual(a.array[0], EnumModel.A)
            XCTAssertEqual(a.array[1], EnumModel.B)
            XCTAssertEqual(a.array[2], EnumModel.C)
            XCTAssertEqual(a.enu, EnumModel.B)
            XCTAssertEqual(a.enu2, EnumModel.A)
            XCTAssertEqual(a.enu3, EnumModel.C)
        } catch let e {
            print(e)
            XCTAssertTrue(false)
        }
    }
}
