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
    @IBOutlet weak var eventsTableView: UITableView!
    
    
    public var loadListEvents: (() -> Void)?
    var listEvents: [EventsViewModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureEvents()
        self.configureTableView()
    }
    
    private func configureEvents() {
        self.loadListEvents?()
    }
    
    private func configureUI() {
        self.loadingActivityIndicator.layer.cornerRadius = 9
    }
    
    private func configureTableView() {
        self.eventsTableView.delegate = self
        self.eventsTableView.dataSource = self
        self.eventsTableView.register(CardTableViewCell.nib(), forCellReuseIdentifier: CardTableViewCell.identifier)
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
            self.loadListEvents?()
        }))
        present(alert, animated: true)
    }
}

extension GetListEventsController: EventsView {
    func showEvents(viewModel: [EventsViewModel]) {
        self.listEvents = viewModel
    }
}

extension GetListEventsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listEvents?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: CardTableViewCell = eventsTableView.dequeueReusableCell(withIdentifier: CardTableViewCell.identifier, for: indexPath) as? CardTableViewCell else { return UITableViewCell() }
        
        cell.setupCell(data: self.listEvents?[indexPath.row] ?? EventsViewModel())
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
    }
}
