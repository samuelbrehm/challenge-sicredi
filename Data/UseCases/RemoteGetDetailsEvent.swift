//
//  RemoteGetDetailsEvent.swift
//  Data
//
//  Created by Samuel Brehm on 03/09/21.
//

import Foundation
import Domain

public class RemoteGetDetailsEvent: GetDetailsEvent {
    private let url: URL
    private let httpGetClient: HttpGetClient
    
    public init(url: URL, httpGetClient: HttpGetClient) {
        self.url = url
        self.httpGetClient = httpGetClient
    }
    
    public func getDetailsEvent(detailsEventParam: DetailsEventParam, completion: @escaping (Result<EventModel, DomainError>) -> Void) {
        httpGetClient.get(to: url, with: detailsEventParam.toData()) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let eventData):
                if let eventModel: EventModel = eventData.toModel() {
                    completion(.success(eventModel))
                } else {
                    completion(.failure(.unexpected))
                }
                
            case .failure: completion(.failure(.unexpected))
            }
        }
    }
}
