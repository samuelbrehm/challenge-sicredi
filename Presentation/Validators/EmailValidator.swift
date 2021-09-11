//
//  EmailValidator.swift
//  Presentation
//
//  Created by Samuel Brehm on 11/09/21.
//

import Foundation

public protocol EmailValidator {
    func isValid(email: String) -> Bool
}
