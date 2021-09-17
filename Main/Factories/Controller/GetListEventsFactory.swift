//
//  ListEventsFactory.swift
//  Main
//
//  Created by Samuel Brehm on 14/09/21.
//

import Foundation
import UI
import Presentation

class GetListEventsFactory {
    static func makeController() -> GetListEventsViewController {
        let controller =  GetListEventsViewController.instantiate()
        let presenter = ListEventsPresenter(getListEvents: makeGetListEvents(), alertView: WeakVarProxy(controller), loadingView: WeakVarProxy(controller), eventsView: WeakVarProxy(controller))
        controller.loadListEvents = presenter.showEventsList
        
        return controller
    }
}
