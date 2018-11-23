//
//  JSON.swift
//  Mappable
//
//  Created by Leavez on 6/1/18.
//

import Foundation

/// a JSON implementation of Mapper
public final class JSONMapper {

    private let jsonValue: Any
    public var options: MapperOptions

    init(JSON: Any, options: MapperOptions? = nil) {
        jsonValue = JSON
        self.options = options ?? MapperOptions()
    }
}

extension JSONMapper: CustomStringConvertible {

    public var description: String {
        return "JSONMapper:\n \(jsonValue)"
    }
}

extension JSONMapper: Mapper {
    

    public func createMapper(with data: Any) -> JSONMapper {
        return JSONMapper(JSON: data, options: options)
    }

    public func getRootValue() -> Any {
        return jsonValue
    }

    public func getValue(keyPath: String, keyPathIsNested: Bool) -> Any? {

        let delimiter: Character = "."

        if !keyPathIsNested || !keyPath.contains(delimiter) {
            let dict = jsonValue as? [String: Any]
            return dict?[keyPath]
        }

        var pathes = ArraySlice(keyPath.split(separator: delimiter))
        var currentValue: Any? = jsonValue

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
