//
//  EventsViewSpy.swift
//  PresentationTests
//
//  Created by Samuel Brehm on 10/09/21.
//

import Foundation
import Presentation

class EventsViewSpy: EventsView {
    var emit: (([EventsViewModel]) -> Void)?
    
    func observe(completion: @escaping ([EventsViewModel]) -> Void) {
        self.emit = completion
    }
    
    func showEvents(viewModel: [EventsViewModel]) {
        self.emit?(viewModel)
    }
}
