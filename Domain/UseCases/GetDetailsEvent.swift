//
//  GetDetailsEvent.swift
//  Domain
//
//  Created by Samuel Brehm on 01/09/21.
//

import Foundation

public protocol GetDetailsEvent {
    func getDetailsEvent(detailsEventParam: DetailsEventParam, completion: @escaping (Result<EventModel, DomainError>) -> Void)
}

public struct DetailsEventParam {
    public var idEvent: String
}
