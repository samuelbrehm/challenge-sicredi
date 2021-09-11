//
//  NewCheckInRequest.swift
//  Presentation
//
//  Created by Samuel Brehm on 11/09/21.
//

import Foundation
import Domain

public struct NewCheckInRequest: Model {
    public var eventId: String
    public var name: String
    public var email: String
    
    public init(eventId: String, name: String, email: String) {
        self.eventId = eventId
        self.name = name
        self.email = email
    }
    
    public func convertToAddCheckInParam() -> AddCheckInParam {
        return AddCheckInParam(eventId: self.eventId, name: self.name, email: self.email)
    }
}
