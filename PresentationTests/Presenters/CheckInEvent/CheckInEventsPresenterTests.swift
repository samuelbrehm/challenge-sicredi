//
//  CheckInEventsPresenterTests.swift
//  PresentationTests
//
//  Created by Samuel Brehm on 11/09/21.
//

import Foundation
import XCTest
import Domain
import Presentation

class CheckInEventsPresenter {
    private let createCheckIn: CreateCheckIn
    private let alertView: AlertView
    
    public init(createCheckIn: CreateCheckIn, alertView: AlertView) {
        self.createCheckIn = createCheckIn
        self.alertView = alertView
    }
    
    func newCheckIn(viewModel: NewCheckInRequest) {
        if let message = validateParams(to: viewModel) {
            self.alertView.showMessage(viewModel: AlertViewModel(title: "Erro", message: message))
        } else {
            self.createCheckIn.addCheckIn(addCheckInParam: viewModel.convertToAddCheckInParam()) { _ in }
        }
    }
    
    private func validateParams(to viewModel: NewCheckInRequest) -> String? {
        if viewModel.eventId.isEmpty {
            return "A identificação do evento é necessária."
        } else if viewModel.name.isEmpty {
            return "O campo nome é obrigatório."
        }
        return nil
    }
}

class CheckInEventsPresenterTests: XCTestCase {
    func test_newCheckIn_should_call_addCheckIn_with_correct_params_values() throws {
        let createCheckInSpy = CreateCheckInSpy()
        let alertViewSpy = AlertViewSpy()
        let sut = CheckInEventsPresenter(createCheckIn: createCheckInSpy, alertView: alertViewSpy)
        sut.newCheckIn(viewModel: makeNewCheckInRequest())
        XCTAssertEqual(createCheckInSpy.addCheckInParam, makeAddCheckInParam())
    }
    
    func test_newCheckIn_should_show_error_if_validate_param_value_eventId_fail_when_call_addCheckIn() throws {
        let createCheckInSpy = CreateCheckInSpy()
        let alertViewSpy = AlertViewSpy()
        let sut = CheckInEventsPresenter(createCheckIn: createCheckInSpy, alertView: alertViewSpy)
        let newCheckInRequest = NewCheckInRequest(eventId: "", name: "any-name", email: "any-email@email.com")
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeAlertViewErrorToParamEventId())
            exp.fulfill()
        }
        sut.newCheckIn(viewModel: newCheckInRequest)
        wait(for: [exp], timeout: 1)
    }
    
    func test_newCheckIn_should_show_error_if_validate_param_value_name_fail_when_call_addCheckIn() throws {
        let createCheckInSpy = CreateCheckInSpy()
        let alertViewSpy = AlertViewSpy()
        let sut = CheckInEventsPresenter(createCheckIn: createCheckInSpy, alertView: alertViewSpy)
        let newCheckInRequest = NewCheckInRequest(eventId: "any-id", name: "", email: "any-email@email.com")
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeAlertViewErrorToParamName())
            exp.fulfill()
        }
        sut.newCheckIn(viewModel: newCheckInRequest)
        wait(for: [exp], timeout: 1)
    }
}

struct NewCheckInRequest: Model {
    public var eventId: String
    public var name: String
    public var email: String
    
    public init(eventId: String, name: String, email: String) {
        self.eventId = eventId
        self.name = name
        self.email = email
    }
    
    func convertToAddCheckInParam() -> AddCheckInParam {
        return AddCheckInParam(eventId: self.eventId, name: self.name, email: self.email)
    }
}

// MARK: - EXTENSION

extension CheckInEventsPresenterTests {
    func makeSut() {
        
    }
    
    func makeNewCheckInRequest() -> NewCheckInRequest {
        return NewCheckInRequest(eventId: "any-id", name: "any-name", email: "any-email@email.com")
    }
    
    func makeAlertViewErrorToParamEventId() -> AlertViewModel {
        return AlertViewModel(title: "Erro", message: "A identificação do evento é necessária.")
    }
    
    func makeAlertViewErrorToParamName() -> AlertViewModel {
        return AlertViewModel(title: "Erro", message: "O campo nome é obrigatório.")
    }
    
    class CreateCheckInSpy: CreateCheckIn {
        var completion: ((Result<StatusResponse, DomainError>) -> Void)?
        var addCheckInParam: AddCheckInParam?

        func addCheckIn(addCheckInParam: AddCheckInParam, completion: @escaping (Result<StatusResponse, DomainError>) -> Void) {
            self.completion = completion
            self.addCheckInParam = addCheckInParam
        }
        
        func completionWithError(_ error: DomainError) {
            self.completion?(.failure(error))
        }
        
        func completionWithSuccess(_ status: StatusResponse) {
            self.completion?(.success(status))
        }
    }
}
