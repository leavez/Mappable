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
/// in the protocol shouldn'd be used directly.
///
public protocol Mapper {
    func value(keyPath: String, keyPathIsNested: Bool) -> Any?
    func rootValue() -> Any
    func generateAnother(with data: Any) -> Self
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
        guard let value = self.value(keyPath: keyPath, keyPathIsNested: keyPathIsNested) else {
            throw ErrorType.valueNonExisted
        }
        if let v = value as? T {
            return v
        }
        throw ErrorType.cannotCast(value, "\(T.self)")
    }

    public func from<T: Mappable>(_ keyPath: String, keyPathIsNested: Bool = true) throws -> T {
        guard let value = self.value(keyPath: keyPath, keyPathIsNested: keyPathIsNested) else {
            throw ErrorType.valueNonExisted
        }
        let mapper = self.generateAnother(with: value)
        return try T.init(map:mapper)
    }
}



