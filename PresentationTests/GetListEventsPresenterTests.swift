//
//  PresentationTests.swift
//  PresentationTests
//
//  Created by Samuel Brehm on 09/09/21.
//

import XCTest
import Domain

final class ListEventsPresenter {
    private let getListEvents: GetListEvents
    private let alertView: AlertView
    
    
    init(getListEvents: GetListEvents, alertView: AlertView) {
        self.getListEvents = getListEvents
        self.alertView = alertView
    }
    
    func showEventsList() {
        self.getListEvents.getListEvents { result in
            switch result {
            case .failure: self.alertView.showMessage(viewModel: AlertViewModel(title: "Falha", message: "Erro ao carregar os eventos."))
            case .success: break
            }
        }
    }
}

protocol AlertView {
    func showMessage(viewModel: AlertViewModel)
}

struct AlertViewModel: Equatable {
    var title: String
    var message: String
    
    init(title: String, message: String) {
        self.title = title
        self.message = message
    }
}

class GetListEventsPresenterTests: XCTestCase {

    func test_ListEvents_should_show_alert_error_if_getListEvents_complete_with_error() throws {
        let getListEventsSpy = GetListEventsSpy()
        let alertViewSpy = AlertViewSpy()
        let sut = ListEventsPresenter(getListEvents: getListEventsSpy, alertView: alertViewSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { alertViewModel in
            XCTAssertEqual(alertViewModel, AlertViewModel(title: "Falha", message: "Erro ao carregar os eventos."))
            exp.fulfill()
        }
        sut.showEventsList()
        getListEventsSpy.completeWithError(.unexpected)
        wait(for: [exp], timeout: 1)
    }

}

extension GetListEventsPresenterTests {
    class AlertViewSpy: AlertView {
        var emit: ((AlertViewModel) -> Void)?
        
        func observe(completion: @escaping (AlertViewModel) -> Void) {
            self.emit = completion
        }
        
        func showMessage(viewModel: AlertViewModel) {
            self.emit?(viewModel)
        }
    }
    
    class GetListEventsSpy: GetListEvents {
        var completion: ((Result<[EventModel], DomainError>) -> Void)?
        
        func getListEvents(completion: @escaping (Result<[EventModel], DomainError>) -> Void) {
            self.completion = completion
        }
        
        func completeWithError(_ error: DomainError) {
            self.completion?(.failure(error))
        }
    }
}

