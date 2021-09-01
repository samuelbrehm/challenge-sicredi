//
//  GetEvents.swift
//  Domain
//
//  Created by Samuel Brehm on 01/09/21.
//

import Foundation

public protocol GetListEvents {
    func getListEvents(completion: @escaping (Result<EventModel, Error>) -> Void)
}

public struct EventModel {
    var id: String
    var date: Date
    var description: String
    var latitude: Double
    var longitude: Double
    var pricce: Double
    var title: String
}
