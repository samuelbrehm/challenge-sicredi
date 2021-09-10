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
    private let loadingView: LoadingView
    private let eventsView: EventsView
    
    init(getListEvents: GetListEvents, alertView: AlertView, loadingView: LoadingView, eventsView: EventsView) {
        self.getListEvents = getListEvents
        self.alertView = alertView
        self.loadingView = loadingView
        self.eventsView = eventsView
    }
    
    func showEventsList() {
        self.loadingView.display(viewModel: LoadingViewModel(isLoading: true))
        self.getListEvents.getListEvents { [weak self] result in
            guard let self = self else { return }
            self.loadingView.display(viewModel: LoadingViewModel(isLoading: false))
            switch result {
            case .failure: self.alertView.showMessage(viewModel: AlertViewModel(title: "Falha", message: "Erro ao carregar os eventos."))
            case .success(let listEvents):
                if listEvents.isEmpty {
                    self.alertView.showMessage(viewModel: AlertViewModel(title: "Falha", message: "Erro ao carregar os eventos."))
                } else {
                    let listEventsViewModel: [EventsViewModel] = EventsViewModel().convertToListEventModel(listEventsModel: listEvents)
                    self.eventsView.showEvents(viewModel: listEventsViewModel)
                }
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

public protocol LoadingView {
    func display(viewModel: LoadingViewModel)
}

public struct LoadingViewModel: Equatable {
    public var isLoading: Bool

    public init(isLoading: Bool) {
        self.isLoading = isLoading
    }
}

protocol EventsView {
    func showEvents(viewModel: [EventsViewModel])
}

struct EventsViewModel: Equatable {
    var peoples: [PeopleModel]?
    var date: Date?
    var description: String?
    var image: String?
    var latitude: Double?
    var longitude: Double?
    var price: Double?
    var title: String?
    var id: String?
    
    init () {}
    
    init(peoples: [PeopleModel], date: Date, description: String, image: String, latitude: Double, longitude: Double, price: Double, title: String, id: String) {
        self.peoples = peoples
        self.date = date
        self.description = description
        self.image = image
        self.latitude = latitude
        self.longitude = longitude
        self.price = price
        self.title = title
        self.id = id
    }
    
    func convertToListEventModel(listEventsModel: [EventModel]) -> [EventsViewModel] {
        let listViewModel: [EventsViewModel] = listEventsModel.map { eventModel in
            EventsViewModel(peoples: eventModel.peoples ?? [], date: eventModel.date ?? Date(), description: eventModel.description ?? "", image: eventModel.image ?? "", latitude: eventModel.latitude ?? 0.0, longitude: eventModel.longitude ?? 0.0, price: eventModel.price ?? 0.0, title: eventModel.title ?? "", id: eventModel.id ?? "")
        }
        return listViewModel
    }
}

class GetListEventsPresenterTests: XCTestCase {

    func test_ListEvents_should_show_alert_error_if_getListEvents_complete_with_error() throws {
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
    
    func test_ListEvents_should_show_alert_error_if_getListEvents_complete_with_empty_array() throws {
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
    
    func test_ListEvents_should_load_list_events_if_getListEvents_complete_with_success() throws {
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
    
    func test_ListEvents_should_show_loading_status_before_and_after_getListEvents() throws {
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
    
    class AlertViewSpy: AlertView {
        var emit: ((AlertViewModel) -> Void)?
        
        func observe(completion: @escaping (AlertViewModel) -> Void) {
            self.emit = completion
        }
        
        func showMessage(viewModel: AlertViewModel) {
            self.emit?(viewModel)
        }
    }
    
    class LoadingViewSpy: LoadingView {
        var emit: ((LoadingViewModel) -> Void)?
        
        func observe(completion: @escaping (LoadingViewModel) -> Void) {
            self.emit = completion
        }
        
        func display(viewModel: LoadingViewModel) {
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
        
        func completeWithListEvents(_ listEvents: [EventModel]) {
            self.completion?(.success(listEvents))
        }
    }
    
    class EventsViewSpy: EventsView {
        var emit: (([EventsViewModel]) -> Void)?
        
        func observe(completion: @escaping ([EventsViewModel]) -> Void) {
            self.emit = completion
        }
        
        func showEvents(viewModel: [EventsViewModel]) {
            self.emit?(viewModel)
        }
    }
}

