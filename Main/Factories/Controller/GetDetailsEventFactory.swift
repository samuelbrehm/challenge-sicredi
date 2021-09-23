//
//  GetDetailsEventFactory.swift
//  Main
//
//  Created by Samuel Brehm on 20/09/21.
//

import Foundation
import UI
import Presentation

class GetDetailsEventFactory {
    static func makeController(navigation: NavigationController) -> GetDetailsEventViewController {
        let controller =  GetDetailsEventViewController.instantiate()
        let router = GetDetailsEventRouter(navigation: navigation, createCheckInEventFactory: CreateCheckInEventFactory.makeController)
        let presenter = DetailsEventPresenter(getDetailsEvent: makeGetDetailsEvent(), alertView: WeakVarProxy(controller), loadingView: WeakVarProxy(controller), detailsEventView: WeakVarProxy(controller))
        controller.navigateCheckInEvent = router.goToCreateCheckInEvent
        controller.loadDetailsEvents = presenter.showDetailsEvent
        
        return controller
    }
}
