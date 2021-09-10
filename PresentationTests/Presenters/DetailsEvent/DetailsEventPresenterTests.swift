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

final class DetailsEventPresenter {
    private let getDetailsEvent: GetDetailsEvent
    private let alertView: AlertView
    private let loadingView: LoadingView
    private let eventsView: EventsView
    
    init(getDetailsEvent: GetDetailsEvent, alertView: AlertView, loadingView: LoadingView, eventsView: EventsView) {
        self.getDetailsEvent = getDetailsEvent
        self.alertView = alertView
        self.loadingView = loadingView
        self.eventsView = eventsView
    }
    
    public func showDetailsEvent(idEvent: String) {
        self.getDetailsEvent.getDetailsEvent(idEvent: idEvent) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure:
                self.alertView.showMessage(viewModel: AlertViewModel(title: "Falha", message: "Erro ao carregar os dados do evento."))
            case .success: break
            }
        }
    }
}

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
}

extension DetailsEventPresenterTests {
    func makeSut(getDetailsEventSpy: GetDetailsEventSpy = GetDetailsEventSpy(), alertViewSpy: AlertViewSpy = AlertViewSpy(), loadingViewSpy: LoadingViewSpy = LoadingViewSpy() ,eventsViewSpy: EventsViewSpy = EventsViewSpy() , file: StaticString = #filePath, line: UInt = #line) -> DetailsEventPresenter {
        let sut = DetailsEventPresenter(getDetailsEvent: getDetailsEventSpy, alertView: alertViewSpy, loadingView: loadingViewSpy, eventsView: eventsViewSpy)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
    
    class GetDetailsEventSpy: GetDetailsEvent {
        var completion: ((Result<EventModel, DomainError>) -> Void)?
        
        func getDetailsEvent(idEvent: String, completion: @escaping (Result<EventModel, DomainError>) -> Void) {
            self.completion = completion
        }
        
        func completeWithError(_ error: DomainError) {
            self.completion?(.failure(error))
        }
        
        func completeWithListEvents(_ event: EventModel) {
            self.completion?(.success(event))
        }
    }
    
}
