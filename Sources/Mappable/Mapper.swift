//
//  Mapper.swift
//  Mappable
//
//  Created by Leavez on 6/1/18.
//

import Foundation


/// Describe the data structure that provide the ability to map JSON
/// value (specified by keypath) to strong typed object automatically.
///
/// The main ability implemented in the extension below. The functions
/// in the protocol shouldn'd be used directly, except for in a custom
/// conversion.
///
@dynamicMemberLookup
public protocol Mapper: class {
    
 
    // Methods to get raw value of specified key path from JSON
    func getValue(keyPath: String, keyPathIsNested: Bool) -> Any?
    func getRootValue() -> Any
    
    // Options to configure mapper's behavior
    var options: MapperOptions { set get }
    
    // Method to create a mapper with data. It should inherit the content in
    // `self.options`
    func createMapper(with data: Any) -> Self
}

public struct MapperOptions {

    public enum DateDecodingStrategy {
        // Use secondsSince1970 for number data and iso8601 for string data
        case automatic
        case secondsSince1970
        case millisecondsSince1970
        case iso8601InRFC3339Format
        case formatted(DateFormatter)
    }

    public var dateDecodingStrategy: DateDecodingStrategy = .automatic
}

extension Mapper {

    /// Providing a automatical way to map JSON value to strong typed object with Generic.
    ///
    /// - parameter keyPath: the key path in JSON
    /// - parameter keyPathIsNested: whether the keypath has mult-level paths. E.g. "AAA.BBB" is a
    ///               mult-level keypath, means `dict["AAA"][BBB]`. When keyPathIsNested is false,
    ///               it will treat "AAA.BBB" as a sinle key, means `dict["AAA.BBB"]`. Use "`n`" to
    ///               get the nth value in a array. "AAA.`0`" means `dict['AAA'][0]`.
    ///
    public func from<T>(_ keyPath: String, keyPathIsNested: Bool = true) throws -> T {
        guard let value = getValue(keyPath: keyPath, keyPathIsNested: keyPathIsNested) else {
            throw ErrorType.valueNonExisted(keyPath)
        }
        if let v = value as? T {
            return v
        }
        throw ErrorType.cannotCast(value, "\(T.self)")
    }

    public func from<T: Mappable>(_ keyPath: String, keyPathIsNested: Bool = true) throws -> T {
        guard let value = getValue(keyPath: keyPath, keyPathIsNested: keyPathIsNested) else {
            // special case for Optional
            if let nullableType = T.self as? Nullable.Type {
                return nullableType.nilValue() as! T
            }
            throw ErrorType.valueNonExisted(keyPath)
        }
        let mapper = self.createMapper(with: value)
        return try T.init(map:mapper)
    }


}


extension Mapper {
    
    /// Convenient methods to get the raw JSON value, which may be used in a
    /// custom conversion.
    ///
    public func getValue(_ keyPath: String, keyPathIsNested: Bool = true) -> Any? {
        return getValue(keyPath: keyPath, keyPathIsNested: keyPathIsNested)
    }
    
    public func getValue<T>(_ keyPath: String, keyPathIsNested: Bool = true, as type: T.Type) throws -> T {
        let value = getValue(keyPath: keyPath, keyPathIsNested: keyPathIsNested)
        guard value != nil else {
            throw ErrorType.valueNonExisted(keyPath)
        }
        if let value = value as? T {
            return value
        }
        throw ErrorType.cannotCast(value, "\(T.self)")
    }
    
    /// Convenient method to create a mapper with the data of keypath.
    ///
    public func subMapper(keyPath: String, keyPathIsNested: Bool = true) -> Self? {
        if let value = getValue(keyPath, keyPathIsNested: keyPathIsNested) {
            return self.createMapper(with: value)
        } else {
            return nil
        }
    }
}


extension Mapper {
    
    /// With the help of @dynamicMemberLookup, mapper API could be simplified:
    ///
    ///     // old
    ///     time = try map.from("time")
    ///     // new
    ///     time = try map.time()
    ///
    public subscript<T>(dynamicMember member: String) -> () throws -> T {
        return { try self.from(member) }
    }
    public subscript<T: Mappable>(dynamicMember member: String) -> () throws -> T {
        return { try self.from(member) }
    }
}



