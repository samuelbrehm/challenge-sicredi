//
//  GetListEventsRouter.swift
//  UI
//
//  Created by Samuel Brehm on 22/09/21.
//

import Foundation

public final class GetListEventsRouter {
    private let navigation: NavigationController
    private let getDetailsEventFactory: (NavigationController) -> GetDetailsEventViewController
    
    public init(navigation: NavigationController, getDetailsEventFactory: @escaping (NavigationController) -> GetDetailsEventViewController) {
        self.navigation = navigation
        self.getDetailsEventFactory = getDetailsEventFactory
    }
    
    public func goToGetDetailsEvent(idEvent: String) {
        let detailsEventController = getDetailsEventFactory(navigation)
        detailsEventController.setIdEvent(idEvent: idEvent)
        navigation.pushViewController(detailsEventController)
    }
}
