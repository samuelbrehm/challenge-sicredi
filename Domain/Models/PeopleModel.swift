//
//  PeopleModel.swift
//  Domain
//
//  Created by Samuel Brehm on 01/09/21.
//

import Foundation

public struct PeopleModel: Model {
    public var id: String
    public var eventId: String
    public var name: String
    public var email: String
    
    public init(id: String, eventId: String, name: String, email: String) {
        self.id = id
        self.eventId = eventId
        self.name = name
        self.email = email
    }
}
