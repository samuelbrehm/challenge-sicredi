//
//  GetListEventsController.swift
//  UI
//
//  Created by Samuel Brehm on 13/09/21.
//

import Foundation
import UIKit
import Presentation

final class GetListEventsController: UIViewController {
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    public var showListEvents: (() -> Void)?
    var listEvents: [EventsViewModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    private func configure() {
        self.showListEvents?()
    }
}

extension GetListEventsController: LoadingView {
    func display(viewModel: LoadingViewModel) {
        if viewModel.isLoading {
            view.isUserInteractionEnabled = false
            self.loadingActivityIndicator.startAnimating()
        } else {
            view.isUserInteractionEnabled = true
            self.loadingActivityIndicator.stopAnimating()
        }
    }
    
}

extension GetListEventsController: AlertView {
    func showMessage(viewModel: AlertViewModel) {
        let alert = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Recarregar", style: .default, handler: { _ in
            self.showListEvents?()
        }))
        present(alert, animated: true)
    }
}

extension GetListEventsController: EventsView {
    func showEvents(viewModel: [EventsViewModel]) {
        self.listEvents = viewModel
    }
}
