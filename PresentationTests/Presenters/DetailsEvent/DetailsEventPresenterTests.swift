//
//  DetailsEventPresenterTests.swift
//  PresentationTests
//
//  Created by Samuel Brehm on 10/09/21.
//

import Foundation
import XCTest
import Domain
import Presentation

class DetailsEventPresenterTests: XCTestCase {
    func test_showDetailsEvent_should_show_alert_error_if_getDetailsEvent_complete_with_error() throws {
        let getDetailsEventSpy = GetDetailsEventSpy()
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(getDetailsEventSpy: getDetailsEventSpy, alertViewSpy: alertViewSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { alertViewModel in
            XCTAssertEqual(alertViewModel, AlertViewModel(title: "Falha", message: "Erro ao carregar os dados do evento."))
            exp.fulfill()
        }
        sut.showDetailsEvent(idEvent: "any-id")
        getDetailsEventSpy.completeWithError(.unexpected)
        wait(for: [exp], timeout: 1)
    }
    
    func test_showDetailsEvent_should_load_details_event_if_getDetailsEvent_complete_with_success() throws {
        let getDetailsEventSpy = GetDetailsEventSpy()
        let detailsEventViewSpy = DetailsEventViewSpy()
        let sut = makeSut(getDetailsEventSpy: getDetailsEventSpy, detailsEventViewSpy: detailsEventViewSpy)
        let expectedDetailsEvent: EventModel = makeEventModel()
        let detailsEventConvertViewModel = EventsViewModel(peoples: expectedDetailsEvent.peoples!, date: expectedDetailsEvent.date!, description: expectedDetailsEvent.description!, image: expectedDetailsEvent.image!, latitude: expectedDetailsEvent.latitude!, longitude: expectedDetailsEvent.longitude!, price: expectedDetailsEvent.price!, title: expectedDetailsEvent.title!, id: expectedDetailsEvent.id!)
        let exp = expectation(description: "waiting")
        detailsEventViewSpy.observe { detailsEvent in
            XCTAssertEqual(detailsEvent, detailsEventConvertViewModel)
            exp.fulfill()
        }
        sut.showDetailsEvent(idEvent: "any-id")
        getDetailsEventSpy.completeWithDetailsEvent(expectedDetailsEvent)
        wait(for: [exp], timeout: 1)
    }
    
    func test_showEventsList_should_show_loading_status_before_and_after_getDetailstEvent() throws {
        let loadingViewSpy = LoadingViewSpy()
        let getDetailsEventSpy = GetDetailsEventSpy()
        let sut = makeSut(getDetailsEventSpy: getDetailsEventSpy, loadingViewSpy: loadingViewSpy)
        
        let exp1 = expectation(description: "waiting")
        loadingViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: true))
            exp1.fulfill()
        }
        sut.showDetailsEvent(idEvent: "any-id")
        wait(for: [exp1], timeout: 1)

        let exp2 = expectation(description: "waiting")
        loadingViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: false))
            exp2.fulfill()
        }
        getDetailsEventSpy.completeWithError(.unexpected)
        wait(for: [exp2], timeout: 1)
    }
}

extension DetailsEventPresenterTests {
    func makeSut(getDetailsEventSpy: GetDetailsEventSpy = GetDetailsEventSpy(), alertViewSpy: AlertViewSpy = AlertViewSpy(), loadingViewSpy: LoadingViewSpy = LoadingViewSpy(), detailsEventViewSpy: DetailsEventViewSpy = DetailsEventViewSpy(), file: StaticString = #filePath, line: UInt = #line) -> DetailsEventPresenter {
        let sut = DetailsEventPresenter(getDetailsEvent: getDetailsEventSpy, alertView: alertViewSpy, loadingView: loadingViewSpy, detailsEventView: detailsEventViewSpy)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
