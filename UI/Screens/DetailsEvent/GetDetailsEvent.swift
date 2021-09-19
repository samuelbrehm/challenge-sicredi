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

public final class GetDetailsEventViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var titleEventLabel: UILabel!
    @IBOutlet weak var dayEventLabel: UILabel!
    @IBOutlet weak var monthEventLabel: UILabel!
    @IBOutlet weak var wrapperContetDateView: UIView!
    @IBOutlet weak var descriptionEventLabel: UILabel!
    @IBOutlet weak var locationEventMap: MKMapView!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    public var loadDetailsEvents: ((_ idEvent: String) -> Void)?
    public var detailsEvent: EventsViewModel?
    public var idEvent: String = ""
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    private func configureUI() {
        self.loadingActivityIndicator?.layer.cornerRadius = 9
        
        self.wrapperContetDateView.layer.shadowColor = UIColor(red: 52, green: 199, blue: 89, alpha: 0.2).cgColor
        self.wrapperContetDateView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.wrapperContetDateView.layer.shadowOpacity = 1.0
        self.wrapperContetDateView.layer.masksToBounds = false
        self.wrapperContetDateView.layer.cornerRadius = 6.0
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
