//
//  EventFactory.swift
//  DataTests
//
//  Created by Samuel Brehm on 02/09/21.
//

import Foundation
import Domain

func makeEventModel() -> EventModel {
    var peoples: [PeopleModel] = []
    peoples.append(makePeopleModel())
    return EventModel(peoples: peoples, date: Date(), description: "any-description", image: "any-url-image", latitude: Double.zero, longitude: Double.zero, price: Double.zero, title: "any-title", id: "any-id")
    
}

func makePeopleModel() -> PeopleModel {
    return PeopleModel(id: "any-id", eventId: "any-eventId", name: "any-name", email: "any@email.com")
}
