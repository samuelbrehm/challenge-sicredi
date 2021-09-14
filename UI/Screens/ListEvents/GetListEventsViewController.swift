//
//  GetListEventsController.swift
//  UI
//
//  Created by Samuel Brehm on 13/09/21.
//

import Foundation
import UIKit
import Presentation

public final class GetListEventsViewController: UIViewController, Storyboarded {
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var eventsTableView: UITableView!
    
    
    public var loadListEvents: (() -> Void)?
    var listEvents: [EventsViewModel] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.configureEvents()
        self.configureTableView()
    }
    
    private func configureEvents() {
        self.loadListEvents?()
    }
    
    private func configureUI() {
        self.loadingActivityIndicator?.layer.cornerRadius = 9
    }
    
    private func configureTableView() {
        self.eventsTableView.separatorStyle = .none
        self.eventsTableView.delegate = self
        self.eventsTableView.dataSource = self
        self.eventsTableView.register(CardTableViewCell.nib(), forCellReuseIdentifier: CardTableViewCell.identifier)
    }
}

extension GetListEventsViewController: LoadingView {
    public func display(viewModel: LoadingViewModel) {
        if viewModel.isLoading {
            view.isUserInteractionEnabled = false
            self.loadingActivityIndicator.startAnimating()
        } else {
            view.isUserInteractionEnabled = true
            self.loadingActivityIndicator.stopAnimating()
        }
    }
    
}

extension GetListEventsViewController: AlertView {
    public func showMessage(viewModel: AlertViewModel) {
        let alert = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Recarregar", style: .default, handler: { _ in
            self.loadListEvents?()
        }))
        present(alert, animated: true)
    }
}

extension GetListEventsViewController: EventsView {
    public func showEvents(viewModel: [EventsViewModel]) {
        self.listEvents = viewModel
    }
}

extension GetListEventsViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listEvents.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: CardTableViewCell = eventsTableView.dequeueReusableCell(withIdentifier: CardTableViewCell.identifier, for: indexPath) as? CardTableViewCell else { return UITableViewCell() }
        
        cell.setupCell(data: self.listEvents[indexPath.row])
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
    }
}
