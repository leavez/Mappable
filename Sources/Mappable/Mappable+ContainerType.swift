//
//  Mappable+ContainerType.swift
//  Mappable
//
//  Created by Leavez on 6/1/18.
//

import Foundation

extension Array: Mappable where Element: Mappable {

    public init(map: Mapper) throws {
        let values = try map.rootValue(as: [Any].self)
        self = try values.map {
            let mapper = map.createMapper(with: $0)
            return try Element.init(map: mapper)
        }
    }
}

extension Dictionary: Mappable where Value: Mappable {

    public init(map: Mapper) throws {

        let values = try map.rootValue(as: [Key: Any].self)

        var dict: [Key: Value] = [:]
        try values.forEach { (key, value) in
            let mapper = map.createMapper(with: value)
            dict[key] = try Value.init(map: mapper)
        }
        self = dict
    }
}


extension Set: Mappable {

    public init(map: Mapper) throws {

        let values = try map.rootValue(as: [Any].self)

        if let T = Element.self as? Mappable.Type {
            let array: [Element] = try values.map {
                let mapper = map.createMapper(with: $0)
                return try T.init(map: mapper) as! Element
            }
            self = Set(array)
        } else {
            if let values = values as? [Element] {
                self = Set(values)
            } else {
                throw ErrorType.cannotCast(values, "\(Element.self)")
            }
        }
    }
}


extension Optional: Mappable {

    public init(map: Mapper) throws {
        let value = map.getRootValue()
        let mapper = map.createMapper(with: value)
        
        // Optional don't throw error by defalut.
        if let T = Wrapped.self as? Mappable.Type {
            self = (try? T.init(map: mapper)) as? Wrapped
        } else {
            self = value as? Wrapped
        }
    }
}

protocol Nullable {
    static func nilValue() -> Self
}
extension Optional: Nullable {
    static func nilValue() -> Optional<Wrapped> {
        return nil
    }
}
