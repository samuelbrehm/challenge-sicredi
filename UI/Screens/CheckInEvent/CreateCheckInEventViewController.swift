//
//  CreateCheckInViewController.swift
//  UI
//
//  Created by Samuel Brehm on 23/09/21.
//

import Foundation
import UIKit
import Presentation

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
        
        self.emailTextField.layer.borderColor = Color.primaryBorderTextField.cgColor
        self.emailTextField.layer.borderWidth = 1
        self.emailTextField.layer.cornerRadius = 9.0
        
        self.nameTextField.layer.borderColor = Color.primaryBorderTextField.cgColor
        self.nameTextField.layer.borderWidth = 1
        self.nameTextField.layer.cornerRadius = 9.0
    }
    
    @IBAction func tappedConfirmButton(_ sender: UIButton) {
    }
    
    @IBAction func tappedBackButton(_ sender: UIButton) {
    }
}

extension CreateCheckInEventViewController: LoadingView {
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
