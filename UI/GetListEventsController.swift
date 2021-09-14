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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
