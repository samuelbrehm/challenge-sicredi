//
//  Array+Encoder.swift
//  DataTests
//
//  Created by Samuel Brehm on 04/09/21.
//

import Foundation

extension Array where Element: Encodable {
    func toData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
