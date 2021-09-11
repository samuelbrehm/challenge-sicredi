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
    
    public init(createCheckIn: CreateCheckIn) {
        self.createCheckIn = createCheckIn
    }
    
    func newCheckIn(viewModel: NewCheckInRequest) {
        self.createCheckIn.addCheckIn(addCheckInParam: viewModel.convertToAddCheckInParam()) { _ in }
        
    }
}

class CheckInEventsPresenterTests: XCTestCase {
    func test_newCheckIn_should_call_addCheckIn_with_correct_params_values() throws {
        let createCheckInSpy = CreateCheckInSpy()
        let sut = CheckInEventsPresenter(createCheckIn: createCheckInSpy)
        sut.newCheckIn(viewModel: makeNewCheckInRequest())
        XCTAssertEqual(createCheckInSpy.addCheckInParam, makeAddCheckInParam())
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

extension CheckInEventsPresenterTests {
    func makeSut() {
        
    }
    
    func makeNewCheckInRequest() -> NewCheckInRequest {
        return NewCheckInRequest(eventId: "any-id", name: "any-name", email: "any-email@email.com")
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
