//
//  CreateCheckInEventViewControllerTests.swift
//  UITests
//
//  Created by Samuel Brehm on 23/09/21.
//

import Foundation
import XCTest
import Presentation
import UIKit
@testable import UI

class CreateCheckInEventViewControllerTests: XCTestCase {
    func test_loading_is_hidden_on_start() throws {
        let sut = makeSut()
        XCTAssertEqual(sut.loadingActivityIndicator.isAnimating, false)
    }
}

extension CreateCheckInEventViewControllerTests {
    func makeSut() -> CreateCheckInEventViewController {
        let sut = CreateCheckInEventViewController.instantiate()
        sut.loadViewIfNeeded()
        return sut
    }
}
