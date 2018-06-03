//
//  Utility.swift
//  Mappable
//
//  Created by Leavez on 6/1/18.
//

import Foundation


public enum ErrorType : Error {

    case JSONParseError(String) // JSON string
    case valueNonExisted(String) // keyPath
    case cannotCast(Any?, String) // value, toType
    case JSONStructureNotMatchDesired(Any?, String) // value, pattern

}

extension ErrorType: CustomStringConvertible {

    public var description: String {
        let desc: String
        switch self {
        case .JSONParseError(let text):
            desc = "JSON parse error: " + text
        case .valueNonExisted(let key):
            desc = "value doesn't exist for `\(key)`"
        case .cannotCast(let data, let type):
            desc = "Cannot cast to `\(type)` from `\(data ?? "nil")`"
        case .JSONStructureNotMatchDesired(let data, let type):
            desc = "Json structure cannot match desired type `\(type)`: \(data ?? "nil")"
        }
        return "[Error] " + desc
    }
}


extension Mapper {

    func rootValue<T>(as: T.Type) throws -> T {
        let value = self.getRootValue()
        if let value = value as? T {
            return value
        }
        throw ErrorType.cannotCast(value, "\(T.self)")
    }
}

