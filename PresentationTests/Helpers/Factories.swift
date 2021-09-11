//
//  Factories.swift
//  PresentationTests
//
//  Created by Samuel Brehm on 11/09/21.
//

import Foundation
import Presentation

func makeNewCheckInRequest() -> NewCheckInRequest {
    return NewCheckInRequest(eventId: "any-id", name: "any-name", email: "any-email@email.com")
}

func makeAlertViewExpected(title: String = "Erro", message: String) -> AlertViewModel {
    return AlertViewModel(title: title, message: message)
}
