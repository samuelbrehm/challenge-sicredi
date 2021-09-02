//
//  ExtensionHelpers.swift
//  Data
//
//  Created by Samuel Brehm on 01/09/21.
//

import Foundation

extension Data {
    func toModel<T: Decodable>() -> T? {
        return try? JSONDecoder().decode(T.self, from: self)
    }
}
