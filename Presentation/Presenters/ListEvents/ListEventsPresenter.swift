//
//  ListEventsPresenter.swift
//  Presentation
//
//  Created by Samuel Brehm on 10/09/21.
//

import Foundation
import Domain


public final class ListEventsPresenter {
    private let getListEvents: GetListEvents
    private let alertView: AlertView
    private let loadingView: LoadingView
    private let eventsView: EventsView
    
    public init(getListEvents: GetListEvents, alertView: AlertView, loadingView: LoadingView, eventsView: EventsView) {
        self.getListEvents = getListEvents
        self.alertView = alertView
        self.loadingView = loadingView
        self.eventsView = eventsView
    }
    
    public func showEventsList() {
        self.loadingView.display(viewModel: LoadingViewModel(isLoading: true))
        self.getListEvents.getListEvents { [weak self] result in
            guard let self = self else { return }
            self.loadingView.display(viewModel: LoadingViewModel(isLoading: false))
            switch result {
            case .failure: self.alertView.showMessage(viewModel: AlertViewModel(title: "Falha", message: "Erro ao carregar os eventos."))
            case .success(let listEvents):
                if listEvents.isEmpty {
                    self.alertView.showMessage(viewModel: AlertViewModel(title: "Falha", message: "Erro ao carregar os eventos."))
                } else {
                    let listEventsViewModel: [EventsViewModel] = EventsViewModel().convertToListEventModel(listEventsModel: listEvents)
                    self.eventsView.showEvents(viewModel: listEventsViewModel)
                }
            }
        }
    }
}
