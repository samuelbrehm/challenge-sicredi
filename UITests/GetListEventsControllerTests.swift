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
        let sb = UIStoryboard(name: "GetListEvents", bundle: Bundle(for: GetListEventsController.self))
        let sut = sb.instantiateViewController(identifier: "GetListEventsController") as! GetListEventsController
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.loadingActivityIndicator.isAnimating, false)
    }
    
    func test_controller_implements_loadingView() throws {
        let sb = UIStoryboard(name: "GetListEvents", bundle: Bundle(for: GetListEventsController.self))
        let sut = sb.instantiateViewController(identifier: "GetListEventsController") as! GetListEventsController
        XCTAssertNotNil(sut as LoadingView)
    }
    
    func test_controller_implements_alertView() throws {
        let sb = UIStoryboard(name: "GetListEvents", bundle: Bundle(for: GetListEventsController.self))
        let sut = sb.instantiateViewController(identifier: "GetListEventsController") as! GetListEventsController
        XCTAssertNotNil(sut as AlertView)
    }
    
    func test_controller_implements_eventsView() throws {
        let sb = UIStoryboard(name: "GetListEvents", bundle: Bundle(for: GetListEventsController.self))
        let sut = sb.instantiateViewController(identifier: "GetListEventsController") as! GetListEventsController
        XCTAssertNotNil(sut as EventsView)
    }
}
