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
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, makeAlertViewExpected(message: "A identificação do evento é necessária."))
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
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, makeAlertViewExpected(message: "O campo nome é obrigatório."))
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
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, makeAlertViewExpected(message: "O campo email é obrigatório."))
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
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, makeAlertViewExpected(message: "O email é inválido."))
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
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, makeAlertViewExpected(message: "Erro ao carregar os dados do evento."))
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
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, makeAlertViewExpected(title: "Novo CheckIn", message: "CheckIn criado com sucesso."))
            exp.fulfill()
        }
        sut.newCheckIn(viewModel: makeNewCheckInRequest())
        createCheckInSpy.completionWithSuccess(.success)
        wait(for: [exp], timeout: 1)
    }
    
    func test_newCheckIn_should_show_loading_status_before_and_after_addCheckIn_fail() throws {
        let createCheckInSpy = CreateCheckInSpy()
        let loadingViewSpy = LoadingViewSpy()
        let sut = makeSut(createCheckInSpy: createCheckInSpy, loadingViewSpy: loadingViewSpy)
        
        let exp1 = expectation(description: "waiting")
        loadingViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: true))
            exp1.fulfill()
        }
        sut.newCheckIn(viewModel: makeNewCheckInRequest())
        wait(for: [exp1], timeout: 1)
        
        let exp2 = expectation(description: "waiting")
        loadingViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: false))
            exp2.fulfill()
        }
        createCheckInSpy.completionWithSuccess(.success)
        wait(for: [exp2], timeout: 1)
    }
}

// MARK: - EXTENSION
extension CheckInEventsPresenterTests {
    func makeSut(createCheckInSpy: CreateCheckInSpy = CreateCheckInSpy(), alertViewSpy: AlertViewSpy = AlertViewSpy(), loadingViewSpy: LoadingViewSpy = LoadingViewSpy(), emailValidatorSpy: EmailValidatorSpy = EmailValidatorSpy(), file: StaticString = #filePath, line: UInt = #line) -> CheckInEventsPresenter {
        let sut = CheckInEventsPresenter(createCheckIn: createCheckInSpy, alertView: alertViewSpy, loadingView: loadingViewSpy, emailValidator: emailValidatorSpy)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
