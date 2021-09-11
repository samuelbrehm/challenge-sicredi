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
    private let emailValidator: EmailValidator
    
    public init(createCheckIn: CreateCheckIn, alertView: AlertView, emailValidator: EmailValidator) {
        self.createCheckIn = createCheckIn
        self.alertView = alertView
        self.emailValidator = emailValidator
    }
    
    func newCheckIn(viewModel: NewCheckInRequest) {
        if let message = validateParams(to: viewModel) {
            self.alertView.showMessage(viewModel: AlertViewModel(title: "Erro", message: message))
        } else {
            self.createCheckIn.addCheckIn(addCheckInParam: viewModel.convertToAddCheckInParam()) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure:
                    self.alertView.showMessage(viewModel: AlertViewModel(title: "Erro", message: "Erro ao carregar os dados do evento."))
                case .success:
                    self.alertView.showMessage(viewModel: AlertViewModel(title:"Novo CheckIn", message: "CheckIn criado com sucesso."))
                }
            }
        }
    }
    
    private func validateParams(to viewModel: NewCheckInRequest) -> String? {
        if viewModel.eventId.isEmpty {
            return "A identificação do evento é necessária."
        } else if viewModel.name.isEmpty {
            return "O campo nome é obrigatório."
        } else if viewModel.email.isEmpty {
            return "O campo email é obrigatório."
        } else if !emailValidator.isValid(email: viewModel.email) {
            return "O email é inválido."
        }
        return nil
    }
}

protocol EmailValidator {
    func isValid(email: String) -> Bool
}

class CheckInEventsPresenterTests: XCTestCase {
    func test_newCheckIn_should_call_addCheckIn_with_correct_params_values() throws {
        let createCheckInSpy = CreateCheckInSpy()
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(createCheckInSpy: createCheckInSpy, alertViewSpy: alertViewSpy)
        sut.newCheckIn(viewModel: makeNewCheckInRequest())
        XCTAssertEqual(createCheckInSpy.addCheckInParam, makeAddCheckInParam())
    }
    
    func test_newCheckIn_should_show_error_if_validate_param_value_eventId_fail_when_call_addCheckIn() throws {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertViewSpy: alertViewSpy)
        let newCheckInRequest = NewCheckInRequest(eventId: "", name: "any-name", email: "any-email@email.com")
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeAlertViewExpected(message: "A identificação do evento é necessária."))
            exp.fulfill()
        }
        sut.newCheckIn(viewModel: newCheckInRequest)
        wait(for: [exp], timeout: 1)
    }
    
    func test_newCheckIn_should_show_error_if_validate_param_value_name_fail_when_call_addCheckIn() throws {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertViewSpy: alertViewSpy)
        let newCheckInRequest = NewCheckInRequest(eventId: "any-id", name: "", email: "any-email@email.com")
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeAlertViewExpected(message: "O campo nome é obrigatório."))
            exp.fulfill()
        }
        sut.newCheckIn(viewModel: newCheckInRequest)
        wait(for: [exp], timeout: 1)
    }
    
    func test_newCheckIn_should_show_error_if_validate_param_value_email_fail_when_call_addCheckIn() throws {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertViewSpy: alertViewSpy)
        let newCheckInRequest = NewCheckInRequest(eventId: "any-id", name: "any-name", email: "")
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeAlertViewExpected(message: "O campo email é obrigatório."))
            exp.fulfill()
        }
        sut.newCheckIn(viewModel: newCheckInRequest)
        wait(for: [exp], timeout: 1)
    }
    
    func test_newCheckIn_should_show_error_if_validate_param_value_email_isInvalid_fail_when_call_addCheckIn() throws {
        let alertViewSpy = AlertViewSpy()
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSut(alertViewSpy: alertViewSpy, emailValidatorSpy: emailValidatorSpy)
        let newCheckInRequest = NewCheckInRequest(eventId: "any-id", name: "any-name", email: "invalid-email@email.com")
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeAlertViewExpected(message: "O email é inválido."))
            exp.fulfill()
        }
        emailValidatorSpy.isValidEmail = false
        sut.newCheckIn(viewModel: newCheckInRequest)
        wait(for: [exp], timeout: 1)
    }
    
    func test_newCheckIn_should_show_error_if_addCheckIn_fail() throws {
        let createCheckInSpy = CreateCheckInSpy()
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(createCheckInSpy: createCheckInSpy, alertViewSpy: alertViewSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeAlertViewExpected(message: "Erro ao carregar os dados do evento."))
            exp.fulfill()
        }
        sut.newCheckIn(viewModel: makeNewCheckInRequest())
        createCheckInSpy.completionWithError(.unexpected)
        wait(for: [exp], timeout: 1)
    }
    
    func test_newCheckIn_should_show_alert_success_message_if_addCheckIn_complete_with_success() throws {
        let createCheckInSpy = CreateCheckInSpy()
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(createCheckInSpy: createCheckInSpy, alertViewSpy: alertViewSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeAlertViewExpected(title: "Novo CheckIn", message: "CheckIn criado com sucesso."))
            exp.fulfill()
        }
        sut.newCheckIn(viewModel: makeNewCheckInRequest())
        createCheckInSpy.completionWithSuccess(.success)
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
    func makeSut(createCheckInSpy: CreateCheckInSpy = CreateCheckInSpy(), alertViewSpy: AlertViewSpy = AlertViewSpy(), emailValidatorSpy: EmailValidatorSpy = EmailValidatorSpy(), file: StaticString = #filePath, line: UInt = #line) -> CheckInEventsPresenter {
        let sut = CheckInEventsPresenter(createCheckIn: createCheckInSpy, alertView: alertViewSpy, emailValidator: emailValidatorSpy)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
    
    func makeNewCheckInRequest() -> NewCheckInRequest {
        return NewCheckInRequest(eventId: "any-id", name: "any-name", email: "any-email@email.com")
    }
    
    func makeAlertViewExpected(title: String = "Erro", message: String) -> AlertViewModel {
        return AlertViewModel(title: title, message: message)
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
    
    class EmailValidatorSpy: EmailValidator {
        var isValidEmail: Bool = true
        var email: String?
        
        func isValid(email: String) -> Bool {
            self.email = email
            return isValidEmail
        }
    }
}
