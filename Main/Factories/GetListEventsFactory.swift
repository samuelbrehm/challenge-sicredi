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

class GetListEventsFactory {
    static func makeController() -> GetListEventsViewController {
        let controller =  GetListEventsViewController.instantiate()
        let alamofireAdapter = AlamofireAdapter()
        let url = URL(string: "http://5f5a8f24d44d640016169133.mockapi.io/api/events")!
        let remoteGetListEvents = RemoteGetListEvents(url: url, httpGetClient: alamofireAdapter)
        let presenter = ListEventsPresenter(getListEvents: remoteGetListEvents, alertView: controller, loadingView: controller, eventsView: controller)
        controller.loadListEvents = presenter.showEventsList
        
        return controller
    }
}
