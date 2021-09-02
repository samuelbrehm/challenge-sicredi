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
        httpGetClient.get(to: url) { result in
            switch result {
            case .success(let data):         
                let eventData = data.filter({ !($0.isEmpty) })
                let envetModelList: [EventModel] = eventData.compactMap({ $0.toModel() })
                completion(.success(envetModelList))
            case .failure: completion(.failure(.unexpected))
            }
            
        }
    }
}
