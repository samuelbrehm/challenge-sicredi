//
//  CheckInEventsPresenter.swift
//  Presentation
//
//  Created by Samuel Brehm on 11/09/21.
//

import Foundation
import Domain

public class CheckInEventsPresenter {
    private let createCheckIn: CreateCheckIn
    private let alertView: AlertView
    private let loadingView: LoadingView
    private let emailValidator: EmailValidator
    
    public init(createCheckIn: CreateCheckIn, alertView: AlertView, loadingView: LoadingView, emailValidator: EmailValidator) {
        self.createCheckIn = createCheckIn
        self.alertView = alertView
        self.loadingView = loadingView
        self.emailValidator = emailValidator
    }
    
    public func newCheckIn(viewModel: NewCheckInRequest) {
        self.loadingView.display(viewModel: LoadingViewModel(isLoading: true))
        if let message = validateParams(to: viewModel) {
            self.alertView.showMessage(viewModel: AlertViewModel(title: "Erro", message: message))
        } else {
            self.createCheckIn.addCheckIn(addCheckInParam: viewModel.convertToAddCheckInParam()) { [weak self] result in
                guard let self = self else { return }
                self.loadingView.display(viewModel: LoadingViewModel(isLoading: false))
                switch result {
                case .failure:
                    self.alertView.showMessage(viewModel: AlertViewModel(title: "Erro", message: "Erro ao carregar os dados do evento."))
                case .success:
                    self.alertView.showMessage(viewModel: AlertViewModel(title:"Novo CheckIn", message: "CheckIn criado com sucesso."))
                }
            }
        }
    }
    
    private func validateParams(to viewModel: NewCheckInRequest) -> String? {
        if viewModel.eventId.isEmpty {
            return "A identificação do evento é necessária."
        } else if viewModel.name.isEmpty {
            return "O campo nome é obrigatório."
        } else if viewModel.email.isEmpty {
            return "O campo email é obrigatório."
        } else if !emailValidator.isValid(email: viewModel.email) {
            return "O email é inválido."
        }
        return nil
    }
}
