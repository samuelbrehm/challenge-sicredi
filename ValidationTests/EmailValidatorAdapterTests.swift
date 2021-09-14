//
//  ValidationTests.swift
//  ValidationTests
//
//  Created by Samuel Brehm on 14/09/21.
//

import XCTest
import Presentation

public class EmailValidatorAdapter: EmailValidator {
    private let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    public func isValid(email: String) -> Bool {
        let range = NSRange(location: 0, length: email.utf16.count)
        let regex = try! NSRegularExpression(pattern: pattern)
        return regex.firstMatch(in: email, options: [], range: range) != nil
    }
}

class EmailValidatorAdapterTests: XCTestCase {
    func test_invalid_emails() throws {
        let sut = EmailValidatorAdapter()
        XCTAssertFalse(sut.isValid(email: "ss"))
        XCTAssertFalse(sut.isValid(email: "ss@"))
        XCTAssertFalse(sut.isValid(email: "ss@ss"))
        XCTAssertFalse(sut.isValid(email: "ss@ss."))
        XCTAssertFalse(sut.isValid(email: "@ss.com"))
    }
}