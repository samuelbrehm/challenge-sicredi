//
//  ValidationTests.swift
//  ValidationTests
//
//  Created by Samuel Brehm on 14/09/21.
//

import XCTest
import Validation

class EmailValidatorAdapterTests: XCTestCase {
    func test_invalid_emails() throws {
        let sut = makeSut()
        XCTAssertFalse(sut.isValid(email: "ss"))
        XCTAssertFalse(sut.isValid(email: "ss@"))
        XCTAssertFalse(sut.isValid(email: "ss@ss"))
        XCTAssertFalse(sut.isValid(email: "ss@ss."))
        XCTAssertFalse(sut.isValid(email: "@ss.com"))
    }
    
    func test_valid_emails() throws {
        let sut = makeSut()
        XCTAssertTrue(sut.isValid(email: "any-name@gmail.com"))
        XCTAssertTrue(sut.isValid(email: "any-name@email.com"))
        XCTAssertTrue(sut.isValid(email: "any-email@outlook.com"))
        XCTAssertTrue(sut.isValid(email: "any-email@outlook.com.br"))
    }
}

extension EmailValidatorAdapterTests {
    func makeSut() -> EmailValidatorAdapter {
        return EmailValidatorAdapter()
    }
}
