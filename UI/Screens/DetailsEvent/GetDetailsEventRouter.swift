//
//  GetDetailsEventRouter.swift
//  UI
//
//  Created by Samuel Brehm on 23/09/21.
//

import Foundation

public final class GetDetailsEventRouter {
    private let navigation: NavigationController
    private let createCheckInEventFactory: () -> CreateCheckInEventViewController
    
    public init(navigation: NavigationController, createCheckInEventFactory: @escaping () -> CreateCheckInEventViewController) {
        self.navigation = navigation
        self.createCheckInEventFactory = createCheckInEventFactory
    }
    
    public func goToCreateCheckInEvent(idEvent: String) {
        let createCheckIncontroller = createCheckInEventFactory()
        createCheckIncontroller.setIdEvent(idEvent: idEvent)
        navigation.present(createCheckIncontroller)
    }
}
