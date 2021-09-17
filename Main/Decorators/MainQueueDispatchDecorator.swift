//
//  MainQueueDispatchDecorator.swift
//  Main
//
//  Created by Samuel Brehm on 17/09/21.
//

import Foundation
import Domain

public final class MainQueueDispatchDecorator<T> {
    private let instance: T
    
    public init(_ instance: T) {
        self.instance = instance
    }
}

extension MainQueueDispatchDecorator: GetListEvents where T: GetListEvents {
    public func getListEvents(completion: @escaping (Result<[EventModel], DomainError>) -> Void) {
        instance.getListEvents { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
