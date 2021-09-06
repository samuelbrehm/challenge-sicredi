//
//  ExtensionHelpers.swift
//  Data
//
//  Created by Samuel Brehm on 01/09/21.
//

import Foundation

public extension Data {
    func toModel<T: Decodable>() -> T? {
        return try? JSONDecoder().decode(T.self, from: self)
    }
    
    func toArrayModel<T: Decodable>() -> [T]? {
        return try? JSONDecoder().decode([T].self, from: self)
    }
    
    func toJson() -> [String: Any]? {
        return try? JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [String: Any]
    }
}
