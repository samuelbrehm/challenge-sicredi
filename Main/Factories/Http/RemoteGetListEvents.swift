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
    let remoteGetListEvents = RemoteGetListEvents(url: makeApiBaseUrl(), httpGetClient: makeAlamofireAdapter())
    return MainQueueDispatchDecorator(remoteGetListEvents)
}

final class MainQueueDispatchDecorator<T> {
    private let instance: T
    
    init(_ instance: T) {
        self.instance = instance
    }
}

extension MainQueueDispatchDecorator: GetListEvents where T: GetListEvents {
    func getListEvents(completion: @escaping (Result<[EventModel], DomainError>) -> Void) {
        instance.getListEvents { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
