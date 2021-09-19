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
