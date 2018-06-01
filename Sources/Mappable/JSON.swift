//
//  JSON.swift
//  Mappable
//
//  Created by Leavez on 6/1/18.
//

import Foundation

/// a JSON implementation of Mapper
public struct JSON {

    private let value: Any

    public init(_ JSON: Any) {
        self.value = JSON
    }
}

extension JSON: CustomStringConvertible {

    public var description: String {
        return "JSON: \(value)"
    }
}

extension JSON: Mapper {

    public func generateAnother(with data: Any) -> JSON {
        return JSON(data)
    }

    public func rootValue() -> Any {
        return value
    }

    public func value(keyPath: String, keyPathIsNested: Bool) -> Any? {

        let delimiter: Character = "."

        if !keyPathIsNested || !keyPath.contains(delimiter) {
            let dict = value as? [String: Any]
            return dict?[keyPath]
        }

        var pathes = ArraySlice(keyPath.split(separator: delimiter))
        var currentValue: Any? = value

        while let _key = pathes.popFirst() {
            let key = String(_key)
            if let result = arrayIndexKeyRegex.firstMatch(in: key, options: [], range: NSMakeRange(0, key.count)) {
                // trade "`0`" as an index for array
                let match = (key as NSString).substring(with: result.range(at: 1))
                guard let index = Int(match) else {
                    return nil
                }
                // array
                if let array = currentValue as? [Any], array.count > index {
                    currentValue = array[index]
                } else {
                    return nil
                }
            } else {
                // dictionay
                if let dict = currentValue as? [String: Any] {
                    currentValue = dict[key]
                } else {
                    return nil
                }
            }
        }
        return currentValue
    }
}

private let arrayIndexKeyRegex = try! NSRegularExpression(pattern: "^`([0-9]+)`$", options: [])
