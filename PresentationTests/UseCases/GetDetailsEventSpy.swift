//
//  GetDetailsEventSpy.swift
//  PresentationTests
//
//  Created by Samuel Brehm on 10/09/21.
//

import Foundation
import Domain

class GetDetailsEventSpy: GetDetailsEvent {
    var completion: ((Result<EventModel, DomainError>) -> Void)?
    
    func getDetailsEvent(idEvent: String, completion: @escaping (Result<EventModel, DomainError>) -> Void) {
        self.completion = completion
    }
    
    func completeWithError(_ error: DomainError) {
        self.completion?(.failure(error))
    }
    
    func completeWithDetailsEvent(_ event: EventModel) {
        self.completion?(.success(event))
    }
}
