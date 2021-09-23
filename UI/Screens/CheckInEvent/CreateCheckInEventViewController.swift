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
    
    private var idEvent: String = ""
    
    public var createCheckIn: ((_ viewModel: NewCheckInRequest) -> Void)?
    
    public override func viewDidLoad() {
        self.configureUI()
    }
    
    public func setIdEvent(idEvent: String) {
        self.idEvent = idEvent
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
        let viewModel = NewCheckInRequest(eventId: self.idEvent, name: nameTextField.text ?? "", email: emailTextField.text ?? "")
        self.createCheckIn?(viewModel)
    }
    
    @IBAction func tappedBackButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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

extension CreateCheckInEventViewController: AlertView {
    public func showMessage(viewModel: AlertViewModel) {
        let alert = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: viewModel.title == "Erro" ? "Tente novamente" : "Ok", style: .default, handler: { _ in
            if viewModel.title != "Erro" {
                self.dismiss(animated: true, completion: nil)
            }
        }))
        present(alert, animated: true)
    }
}
