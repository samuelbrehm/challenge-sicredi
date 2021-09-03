//
//  CreateCheckInFactory.swift
//  DataTests
//
//  Created by Samuel Brehm on 03/09/21.
//

import Foundation
import Domain

func makeAddCheckInParam() -> AddCheckInParam {
    let expectParams = AddCheckInParam(eventId: "any-id", name: "any-name", email: "any-email@email.com")
    return expectParams
}


