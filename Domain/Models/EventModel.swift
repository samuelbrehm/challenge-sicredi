//
//  EventModel.swift
//  Domain
//
//  Created by Samuel Brehm on 01/09/21.
//

import Foundation

public struct EventModel {
    var Peoples: [PeopleModel]
    var date: Date
    var description: String
    var image: String
    var latitude: Double
    var longitude: Double
    var price: Double
    var title: String
    var id: String
}
