//
//  CreateCheckIn.swift
//  Domain
//
//  Created by Samuel Brehm on 01/09/21.
//

import Foundation

public protocol CreateCheckIn {
    func addCheckIn(addCheckInParam: AddCheckInParam, completion: @escaping (Result<StatusResponse, Error>) -> Void)
}

public enum StatusResponse {
    case ok
}

public struct AddCheckInParam {
    var eventId: String
    var name: String
    var email: String
}
