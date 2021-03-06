//
//  RemoteGetDetailsEvent.swift
//  Data
//
//  Created by Samuel Brehm on 03/09/21.
//

import Foundation
import Domain

public class RemoteGetDetailsEvent: GetDetailsEvent {
    private var url: URL
    private let httpGetClient: HttpGetClient
    
    public init(url: URL, httpGetClient: HttpGetClient) {
        self.url = url
        self.httpGetClient = httpGetClient
    }
    
    public func getDetailsEvent(idEvent: String, completion: @escaping (Result<EventModel, DomainError>) -> Void) {
        self.url = self.url.appendingPathComponent(idEvent)
        httpGetClient.get(to: url, with: nil) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let eventData):
                if let eventModel: EventModel = eventData?.toModel() {
                    completion(.success(eventModel))
                }
            case .failure: completion(.failure(.unexpected))
            }
        }
    }
}
