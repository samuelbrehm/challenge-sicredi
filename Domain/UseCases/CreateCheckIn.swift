//
//  CreateCheckIn.swift
//  Domain
//
//  Created by Samuel Brehm on 01/09/21.
//

import Foundation

public protocol CreateCheckIn {
    func addCheckIn(addCheckInParam: AddCheckInParam, completion: @escaping (Result<StatusResponse, DomainError>) -> Void)
}

public enum StatusResponse {
    case success
    case failure
}

public struct AddCheckInParam: Model {
    public var eventId: String
    public var name: String
    public var email: String
    
    public init(eventId: String, name: String, email: String) {
        self.eventId = eventId
        self.name = name
        self.email = email
    }
}
