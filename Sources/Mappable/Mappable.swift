//
//  Mappable.swift
//  Mappable
//
//  Created by Leavez on 6/1/18.
//

import Foundation

/// This is the protocol the models should be conformed with.
///
public protocol Mappable {
    init(map: Mapper) throws
}




/// Conveint initializers for JSON
public extension Mappable {

    /// Initializes object from a JSON object
    ///
    /// A JSON object could be Dictionary, Array or plain String/Number value. It could
    /// be the result of JSONSerialization(jsonObject:options:).
    public init(JSONObject: Any) throws {
        let mapper = JSONMapper(JSON: JSONObject)
        try self.init(map: mapper)
    }
    public init(JSONObject: [String: Any]) throws {
        let mapper = JSONMapper(JSON: JSONObject)
        try self.init(map: mapper)
    }

    /// Initializes object from a JSON String
    public init(JSONString: String) throws {
        guard let data = JSONString.data(using: String.Encoding.utf8, allowLossyConversion: true)
            else {
                throw ErrorType.JSONParseError(JSONString)
        }
        try self.init(JSONData: data)
    }

    /// Initializes object from a JSON data
    public init(JSONData: Data) throws {
        let json = try JSONSerialization.jsonObject(with: JSONData, options: JSONSerialization.ReadingOptions.allowFragments)
        let mapper = JSONMapper(JSON: json)
        try self.init(map: mapper)
    }
}




