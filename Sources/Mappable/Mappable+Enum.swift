//
//  Mappable+Enum.swift
//  Mappable
//
//  Created by Leavez on 6/1/18.
//

import Foundation

extension RawRepresentable {

    public init(map: Mapper) throws {
        let value = try map.rootValue(as: RawValue.self)
        if let v = Self.init(rawValue: value) {
            self = v
        } else {
            throw ErrorType.cannotCast(value, "\(Self.self)")
        }
    }
}
