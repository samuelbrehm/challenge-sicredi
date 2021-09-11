//
//  EmailValidatorSpy.swift
//  PresentationTests
//
//  Created by Samuel Brehm on 11/09/21.
//

import Foundation
import Presentation

class EmailValidatorSpy: EmailValidator {
    var isValidEmail: Bool = true
    var email: String?
    
    func isValid(email: String) -> Bool {
        self.email = email
        return isValidEmail
    }
}
