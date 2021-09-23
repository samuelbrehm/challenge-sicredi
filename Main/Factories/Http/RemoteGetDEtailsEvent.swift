//
//  RemoteGetDEtailsEvent.swift
//  Main
//
//  Created by Samuel Brehm on 20/09/21.
//

import Foundation
import Domain
import Data

func makeGetDetailsEvent() -> GetDetailsEvent {
    let remoteGetDetailsEvent = RemoteGetDetailsEvent(url: APIUrlFactory.makeApiBaseUrl(path: .events) , httpGetClient: makeAlamofireAdapter())
    return MainQueueDispatchDecorator(remoteGetDetailsEvent)
}
