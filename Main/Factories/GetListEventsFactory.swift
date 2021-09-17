//
//  ListEventsFactory.swift
//  Main
//
//  Created by Samuel Brehm on 14/09/21.
//

import Foundation
import UI
import Presentation
import Data
import Infra_
import Domain

class GetListEventsFactory {
    static func makeController() -> GetListEventsViewController {
        let controller =  GetListEventsViewController.instantiate()
        let presenter = ListEventsPresenter(getListEvents: makeGetListEvents(), alertView: controller, loadingView: controller, eventsView: controller)
        controller.loadListEvents = presenter.showEventsList
        
        return controller
    }
}
