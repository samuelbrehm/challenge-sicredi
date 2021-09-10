//
//  PresentationTests.swift
//  PresentationTests
//
//  Created by Samuel Brehm on 09/09/21.
//

import XCTest
import Domain
import Presentation

class GetListEventsPresenterTests: XCTestCase {
    func test_showEventsList_should_show_alert_error_if_getListEvents_complete_with_error() throws {
        let getListEventsSpy = GetListEventsSpy()
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(getListEventsSpy: getListEventsSpy, alertViewSpy: alertViewSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { alertViewModel in
            XCTAssertEqual(alertViewModel, AlertViewModel(title: "Falha", message: "Erro ao carregar os eventos."))
            exp.fulfill()
        }
        sut.showEventsList()
        getListEventsSpy.completeWithError(.unexpected)
        wait(for: [exp], timeout: 1)
    }
    
    func test_showEventsList_should_show_alert_error_if_getListEvents_complete_with_empty_array() throws {
        let getListEventsSpy = GetListEventsSpy()
        let eventsViewSpy = EventsViewSpy()
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(getListEventsSpy: getListEventsSpy, alertViewSpy: alertViewSpy, eventsViewSpy: eventsViewSpy)
        let expectedsEvents: [EventModel] = []
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { alertViewModel in
            XCTAssertEqual(alertViewModel, AlertViewModel(title: "Falha", message: "Erro ao carregar os eventos."))
            exp.fulfill()
        }
        sut.showEventsList()
        getListEventsSpy.completeWithListEvents(expectedsEvents)
        wait(for: [exp], timeout: 1)
    }
    
    func test_showEventsList_should_load_list_events_if_getListEvents_complete_with_success() throws {
        let getListEventsSpy = GetListEventsSpy()
        let eventsViewSpy = EventsViewSpy()
        let sut = makeSut(getListEventsSpy: getListEventsSpy, eventsViewSpy: eventsViewSpy)
        let expectedsEvents: [EventModel] = [makeEventModel(), makeEventModel(), makeEventModel()]
        let eventsConvertViewModel: [EventsViewModel] = expectedsEvents.map { eventModel in
            EventsViewModel(peoples: eventModel.peoples!, date: eventModel.date!, description: eventModel.description!, image: eventModel.image!, latitude: eventModel.latitude!, longitude: eventModel.longitude!, price: eventModel.price!, title: eventModel.title!, id: eventModel.id!)
        }
        let exp = expectation(description: "waiting")
        eventsViewSpy.observe { listEvents in
            XCTAssertEqual(listEvents, eventsConvertViewModel)
            exp.fulfill()
        }
        sut.showEventsList()
        getListEventsSpy.completeWithListEvents(expectedsEvents)
        wait(for: [exp], timeout: 1)
    }
    
    func test_showEventsList_should_show_loading_status_before_and_after_getListEvents() throws {
        let loadingViewSpy = LoadingViewSpy()
        let getListEventsSpy = GetListEventsSpy()
        let sut = makeSut(getListEventsSpy: getListEventsSpy, loadingViewSpy: loadingViewSpy)
        
        let exp1 = expectation(description: "waiting")
        loadingViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: true))
            exp1.fulfill()
        }
        sut.showEventsList()
        wait(for: [exp1], timeout: 1)

        let exp2 = expectation(description: "waiting")
        loadingViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: false))
            exp2.fulfill()
        }
        getListEventsSpy.completeWithError(.unexpected)
        wait(for: [exp2], timeout: 1)
    }
}

extension GetListEventsPresenterTests {
    func makeSut(getListEventsSpy: GetListEventsSpy = GetListEventsSpy(), alertViewSpy: AlertViewSpy = AlertViewSpy(), loadingViewSpy: LoadingViewSpy = LoadingViewSpy() ,eventsViewSpy: EventsViewSpy = EventsViewSpy() , file: StaticString = #filePath, line: UInt = #line) -> ListEventsPresenter {
        let sut = ListEventsPresenter(getListEvents: getListEventsSpy, alertView: alertViewSpy, loadingView: loadingViewSpy, eventsView: eventsViewSpy)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}

