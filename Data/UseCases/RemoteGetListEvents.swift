//
//  RemoteGetListEvents.swift
//  Data
//
//  Created by Samuel Brehm on 01/09/21.
//

import Foundation
import Domain

public class RemoteGetListEvents: GetListEvents {
    private let url: URL
    private let httpGetClient: HttpGetClient
    
    public init(url: URL, httpGetClient: HttpGetClient) {
        self.url = url
        self.httpGetClient = httpGetClient
    }
    
    public func getListEvents(completion: @escaping (Result<[EventModel], DomainError>) -> Void) {
        httpGetClient.get(to: url, with: nil) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let data):
                if let eventsListModel: [EventModel] = data?.toArrayModel() {
                    completion(.success(eventsListModel))
                }
            case .failure: completion(.failure(.unexpected))
            }
            
        }
    }
}
