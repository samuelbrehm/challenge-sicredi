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
        let presenter = ListEventsPresenter(getListEvents: makeGetListEvents(), alertView: WeakVarProxy(controller), loadingView: WeakVarProxy(controller), eventsView: WeakVarProxy(controller))
        controller.loadListEvents = presenter.showEventsList
        
        return controller
    }
}

class WeakVarProxy<T: AnyObject> {
    private weak var instance: T?
    
    init(_ instance: T) {
        self.instance = instance
    }
}

extension WeakVarProxy: AlertView where T: AlertView {
    func showMessage(viewModel: AlertViewModel) {
        instance?.showMessage(viewModel: viewModel)
    }
}


extension WeakVarProxy: LoadingView where T: LoadingView {
    func display(viewModel: LoadingViewModel) {
        instance?.display(viewModel: viewModel)
    }
}

extension WeakVarProxy: EventsView where T: EventsView {
    func showEvents(viewModel: [EventsViewModel]) {
        instance?.showEvents(viewModel: viewModel)
    }
    
   
}
