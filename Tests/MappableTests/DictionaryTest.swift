//
//  DictionaryTest.swift
//  MappableTests
//
//  Created by Leavez on 6/1/18.
//

import XCTest
@testable import Mappable

class DictModel: Mappable {
    let primative : [String: Int]
    let model: [String: IntModel]

    required init(map: Mapper) throws {
        primative = try map.from("primative")
        model = try map.from("model")
    }
}


class DictionaryTests: XCTestCase {


    func test() {
        let json = """
{
  "primative": {"1":2,"3":4},
  "model": {"1": {"int": 123}, "2":{"int":456}}
}
"""
        do {
            let a = try DictModel(JSONString: json)
            XCTAssertEqual(["1":2,"3":4], a.primative)
            XCTAssertEqual(a.model["1"]?.int, 123)
            XCTAssertEqual(a.model["2"]?.int, 456)
        } catch let e {
            print(e)
            XCTAssertTrue(false)
        }
    }


}
