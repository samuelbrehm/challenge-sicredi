//
//  EventsView.swift
//  Presentation
//
//  Created by Samuel Brehm on 10/09/21.
//

import Foundation
import Domain

public protocol EventsView {
    func showEvents(viewModel: [EventsViewModel])
}

public struct EventsViewModel: Equatable {
    public var peoples: [PeopleModel]?
    public var date: Date?
    public var description: String?
    public var image: String?
    public var latitude: Double?
    public var longitude: Double?
    public var price: Double?
    public var title: String?
    public var id: String?
    
    public init () {}
    
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
    
    public func convertToListEventModel(listEventsModel: [EventModel]) -> [EventsViewModel] {
        let listViewModel: [EventsViewModel] = listEventsModel.map { eventModel in
            EventsViewModel(peoples: eventModel.peoples ?? [], date: eventModel.date ?? Date(), description: eventModel.description ?? "", image: eventModel.image ?? "", latitude: eventModel.latitude ?? 0.0, longitude: eventModel.longitude ?? 0.0, price: eventModel.price ?? 0.0, title: eventModel.title ?? "", id: eventModel.id ?? "")
        }
        return listViewModel
    }
}
