//
//  GetDetailsEvent.swift
//  Domain
//
//  Created by Samuel Brehm on 01/09/21.
//

import Foundation

public protocol GetDetailsEvent {
    func getDetailsEvent(detailsEventParam: DetailsEventParam, completion: @escaping (Result<EventModel, Error>) -> Void)
}

public struct DetailsEventParam {
    var idEvent: String
}
