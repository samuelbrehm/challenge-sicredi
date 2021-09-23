//
//  RemoteCreateCheckInEvent.swift
//  Main
//
//  Created by Samuel Brehm on 23/09/21.
//

import Foundation
import Domain
import Data

func makeCreateCheckIn() -> CreateCheckIn {
    let remoteCreateCheckInEvent = RemoteCreateCheckIn(httpPostClient: makeAlamofireAdapter(), url: APIUrlFactory.makeApiBaseUrl(path: .checkin))
    return MainQueueDispatchDecorator(remoteCreateCheckInEvent)
}
