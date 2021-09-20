//
//  WeakVarProxy.swift
//  Main
//
//  Created by Samuel Brehm on 17/09/21.
//

import Foundation
import Presentation

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

extension WeakVarProxy: DetailsEventView where T: DetailsEventView {
    func showDetailsEvent(viewModel: EventsViewModel) {
        instance?.showDetailsEvent(viewModel: viewModel)
    }
}
