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
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var checkInButton: UIButton!
    
    public var loadDetailsEvents: ((_ idEvent: String) -> Void)?
    public var detailsEvent: EventsViewModel = EventsViewModel()
    private var idEvent: String = ""
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.loadRemoteDetailsEvent()
    }
    
    public func setIdEvent(idEvent: String) {
        self.idEvent = idEvent
    }
    
    @IBAction func tappedCheckInButton(_ sender: UIButton) {
    }

    private func loadRemoteDetailsEvent() {
        self.loadDetailsEvents?(self.idEvent)
    }
    
    private func configureUI() {
        self.loadingActivityIndicator?.layer.cornerRadius = 9
        
        self.title = "Todas Informações do Evento"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        self.checkInButton.layer.cornerRadius = 9.0
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
        self.descriptionEventLabel.text = self.detailsEvent.description
        if let latitude = self.detailsEvent.latitude, let longitude = self.detailsEvent.longitude {
            self.setLocationEventOnMap(latitude: latitude, longitude: longitude)
            self.setAddressEventWithCoordinates(latitude: latitude, longitude: longitude)
        }
    }
    
    private func setLocationEventOnMap(latitude: Double, longitude: Double) {
        let center = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.006, longitudeDelta: 0.006)
        let region = MKCoordinateRegion(center: center, span: span)
        self.locationEventMap.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        self.locationEventMap.addAnnotation(annotation)
    }
    
    private func setAddressEventWithCoordinates(latitude: Double, longitude: Double) {
        var centerAddress : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let geoCoder: CLGeocoder = CLGeocoder()
        
        let latitude: Double = latitude
        let longitude: Double = longitude
        centerAddress.latitude = latitude
        centerAddress.longitude = longitude
        let location: CLLocation = CLLocation(latitude: centerAddress.latitude, longitude: centerAddress.longitude)
        
        geoCoder.reverseGeocodeLocation(location) { (placemarks, _) in
            let pm = placemarks! as [CLPlacemark]
            if pm.count > 0 {
                let pm = placemarks![0]
                if let thoroughfare = pm.thoroughfare, let subThoroughfare = pm.subThoroughfare, let subLocality = pm.subLocality, let locality = pm.locality, let postalCode = pm.postalCode {
                    self.addressLabel.text = "Endereço: \(thoroughfare), \(subThoroughfare)\nBairro: \(subLocality) - \(locality).\nCEP \(postalCode)"
                }
            }
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
