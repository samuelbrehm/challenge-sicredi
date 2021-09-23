//
//  CreateCheckInViewController.swift
//  UI
//
//  Created by Samuel Brehm on 23/09/21.
//

import Foundation
import UIKit

public final class CreateCheckInEventViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    public override func viewDidLoad() {
        self.configureUI()
    }
    
    private func configureUI() {
        self.loadingActivityIndicator?.layer.cornerRadius = 9.0
        
        self.confirmButton.layer.cornerRadius = 9.0
        self.backButton.layer.cornerRadius = 9.0
    }
    
    @IBAction func tappedConfirmButton(_ sender: UIButton) {
    }
    
    @IBAction func tappedBackButton(_ sender: UIButton) {
    }
}
