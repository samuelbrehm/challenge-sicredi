//
//  DetailsEventPresenter.swift
//  Presentation
//
//  Created by Samuel Brehm on 10/09/21.
//

import Foundation
import Domain

public final class DetailsEventPresenter {
    private let getDetailsEvent: GetDetailsEvent
    private let alertView: AlertView
    private let loadingView: LoadingView
    private let detailsEventView: DetailsEventView
    
    public init(getDetailsEvent: GetDetailsEvent, alertView: AlertView, loadingView: LoadingView, detailsEventView: DetailsEventView) {
        self.getDetailsEvent = getDetailsEvent
        self.alertView = alertView
        self.loadingView = loadingView
        self.detailsEventView = detailsEventView
    }
    
    public func showDetailsEvent(idEvent: String) {
        self.loadingView.display(viewModel: LoadingViewModel(isLoading: true))
        self.getDetailsEvent.getDetailsEvent(idEvent: idEvent) { [weak self] result in
            guard let self = self else { return }
            self.loadingView.display(viewModel: LoadingViewModel(isLoading: false))
            switch result {
            case .failure:
                self.alertView.showMessage(viewModel: AlertViewModel(title: "Falha", message: "Erro ao carregar os dados do evento."))
            case .success(let eventModel):
                let eventViewModel: EventsViewModel = EventsViewModel().convertToEventsViewModel(eventModel: eventModel)
                self.detailsEventView.showDetailsEvent(viewModel: eventViewModel)
            }
        }
    }
}
