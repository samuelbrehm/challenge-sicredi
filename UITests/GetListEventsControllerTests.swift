//
//  UITests.swift
//  UITests
//
//  Created by Samuel Brehm on 13/09/21.
//

import XCTest
import Presentation
import UIKit
@testable import UI

class GetListEventsControllerTests: XCTestCase {
    func test_loading_is_hidden_on_start() throws {
        let sut = makeSut()
        XCTAssertEqual(sut.loadingActivityIndicator.isAnimating, false)
    }
    
    func test_controller_implements_loadingView() throws {
        let sut = makeSut()
        XCTAssertNotNil(sut as LoadingView)
    }
    
    func test_controller_implements_alertView() throws {
        let sut = makeSut()
        XCTAssertNotNil(sut as AlertView)
    }
    
    func test_controller_implements_eventsView() throws {
        let sut = makeSut()
        XCTAssertNotNil(sut as EventsView)
    }
}

extension GetListEventsControllerTests {
    func makeSut() -> GetListEventsViewController {
        let sut = GetListEventsViewController.instantiate()
        sut.loadViewIfNeeded()
        return sut
    }
}
