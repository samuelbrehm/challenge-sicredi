//
//  GetListEventsSpy.swift
//  PresentationTests
//
//  Created by Samuel Brehm on 10/09/21.
//

import Foundation
import Domain

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
