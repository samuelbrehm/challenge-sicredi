//
//  DetailsEventViewSpy.swift
//  PresentationTests
//
//  Created by Samuel Brehm on 10/09/21.
//

import Foundation
import Presentation

class DetailsEventViewSpy: DetailsEventView {
    var emit: ((EventsViewModel) -> Void)?
    
    func observe(completion: @escaping (EventsViewModel) -> Void) {
        self.emit = completion
    }
    
    func showDetailsEvent(viewModel: EventsViewModel) {
        self.emit?(viewModel)
    }
}
