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
    let url = URL(string: "http://5f5a8f24d44d640016169133.mockapi.io/api/events")!
    let remoteGetListEvents = RemoteGetListEvents(url: url, httpGetClient: makeAlamofireAdapter())
    return remoteGetListEvents
}
