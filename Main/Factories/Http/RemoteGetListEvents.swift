//
//  RemoteGetListEvents.swift
//  Main
//
//  Created by Samuel Brehm on 17/09/21.
//

import Foundation
import Domain
import Data

func makeGetListEvents() -> GetListEvents {
    let remoteGetListEvents = RemoteGetListEvents(url: APIUrlFactory.makeApiBaseUrl(path: .events), httpGetClient: makeAlamofireAdapter())
    return MainQueueDispatchDecorator(remoteGetListEvents)
}
