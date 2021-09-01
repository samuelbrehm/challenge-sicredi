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
