//
//  EmailValidatorAdapterFactory.swift
//  Main
//
//  Created by Samuel Brehm on 23/09/21.
//

import Foundation
import Validation

func makeEmailValidator() -> EmailValidatorAdapter {
    return EmailValidatorAdapter()
}
