//
//  EventModel.swift
//  Domain
//
//  Created by Samuel Brehm on 01/09/21.
//

import Foundation

public struct EventModel: Model {
    public var peoples: [PeopleModel]?
    public var date: Date?
    public var description: String?
    public var image: String?
    public var latitude: Double?
    public var longitude: Double?
    public var price: Double?
    public var title: String?
    public var id: String?
    
    public init(peoples: [PeopleModel], date: Date, description: String, image: String, latitude: Double, longitude: Double, price: Double, title: String, id: String) {
        self.peoples = peoples
        self.date = date
        self.description = description
        self.image = image
        self.latitude = latitude
        self.longitude = longitude
        self.price = price
        self.title = title
        self.id = id
    }
}
