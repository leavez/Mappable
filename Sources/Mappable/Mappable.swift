//
//  Mappable.swift
//  Mappable
//
//  Created by Leavez on 6/1/18.
//

import Foundation

/// 
///
///
public protocol Mappable {
    init(map: Mapper) throws
}




/// Conveint initializers for JSON
public extension Mappable {

    /// Initializes object from a JSONObject
    public init(JSONObject: [String: Any]) throws {
        let mapper = JSON(JSONObject)
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
        let mapper = JSON(json)
        try self.init(map: mapper)
    }
}




