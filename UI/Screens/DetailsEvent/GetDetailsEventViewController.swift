//
//  GetDetailsEvent.swift
//  UI
//
//  Created by Samuel Brehm on 19/09/21.
//

import Foundation

import UIKit
import MapKit
import Presentation
import Kingfisher

public final class GetDetailsEventViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var titleEventLabel: UILabel!
    @IBOutlet weak var dateEventLabel: UILabel!
    @IBOutlet weak var descriptionEventLabel: UILabel!
    @IBOutlet weak var locationEventMap: MKMapView!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    public var loadDetailsEvents: ((_ idEvent: String) -> Void)?
    public var detailsEvent: EventsViewModel = EventsViewModel()
    public var idEvent: String = ""
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.loadRemoteDetailsEvent()
        
    }
    
    private func loadRemoteDetailsEvent() {
        self.idEvent = "1"
        self.loadDetailsEvents?(self.idEvent)
    }
    
    private func configureUI() {
        self.loadingActivityIndicator?.layer.cornerRadius = 9
    }
    
    private func configureEventViewModel() {
        let url: URL = URL(string: self.detailsEvent.image ?? "")!
        let placeholder: UIImage = UIImage(named: "event4")!
        
        let processor = DownsamplingImageProcessor(size: self.eventImageView.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 20)
        self.eventImageView.kf.indicatorType = .activity
        
        self.eventImageView.kf.setImage(with: url, placeholder: placeholder, options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
            ])
        self.titleEventLabel.text = self.detailsEvent.title
        if let date = self.detailsEvent.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM - HH:mm 'h'"
            let dateEventFormatted  = dateFormatter.string(from: date)
            self.dateEventLabel.text = dateEventFormatted
        }
    }
}

extension GetDetailsEventViewController: LoadingView {
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

extension GetDetailsEventViewController: AlertView {
    public func showMessage(viewModel: AlertViewModel) {
        let alert = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Recarregar", style: .default, handler: { _ in
            self.loadDetailsEvents?(self.idEvent)
        }))
        present(alert, animated: true)
    }
}

extension GetDetailsEventViewController: DetailsEventView {
    public func showDetailsEvent(viewModel: EventsViewModel) {
        self.detailsEvent = viewModel
        self.configureEventViewModel()
    }
}
