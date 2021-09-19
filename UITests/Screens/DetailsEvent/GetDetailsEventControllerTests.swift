//
//  GetDetailsEventControllerTests.swift
//  UITests
//
//  Created by Samuel Brehm on 19/09/21.
//

import Foundation
import XCTest
import Presentation
import UIKit
@testable import UI

class GetDetailsEventControllerTests: XCTestCase {
    func test_loading_is_hidden_on_start() throws {
        let sut = makeSut()
        XCTAssertEqual(sut.loadingActivityIndicator.isAnimating, false)
    }
}

extension GetDetailsEventControllerTests {
    func makeSut() -> GetDetailsEventViewController {
        let sut = GetDetailsEventViewController.instantiate()
        sut.loadViewIfNeeded()
        return sut
    }
}
