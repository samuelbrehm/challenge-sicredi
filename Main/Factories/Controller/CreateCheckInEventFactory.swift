//
//  CreateCheckInEventFactory.swift
//  Main
//
//  Created by Samuel Brehm on 23/09/21.
//

import Foundation
import UI
import Presentation

class CreateCheckInEventFactory {
    static func makeController() -> CreateCheckInEventViewController {
        let controller = CreateCheckInEventViewController.instantiate()
        let presenter = CheckInEventsPresenter(createCheckIn: makeCreateCheckIn(), alertView: WeakVarProxy(controller), loadingView: WeakVarProxy(controller), emailValidator: makeEmailValidator())
        controller.createCheckIn = presenter.newCheckIn
        
        return controller
    }
}
