//
//  CreateCheckInSpy.swift
//  PresentationTests
//
//  Created by Samuel Brehm on 11/09/21.
//

import Foundation
import Domain

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
