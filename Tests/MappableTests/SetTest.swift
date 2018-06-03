//
//  DictionaryTest.swift
//  MappableTests
//
//  Created by Leavez on 6/1/18.
//

import XCTest
@testable import Mappable

class SetModel: Mappable {
    let primative : Set<String>
    let model: Set<IntModel>

    required init(map: Mapper) throws {
        primative = try map.from("primative")
        model = try map.from("model")
    }
}


class SetTests: XCTestCase {


    func test() {
        let json = """
{
  "primative": ["a", "b", "c"],
  "model": [ {"int": 123}, {"int":456} ]
}
"""
        do {
            let a = try SetModel(JSONString: json)
            XCTAssertEqual(["a", "b", "c"], a.primative)
            XCTAssertEqual(Set(a.model.map{ $0.int }), Set([123, 456]))
        } catch let e {
            XCTFail(e.localizedDescription)
        }
    }


}
