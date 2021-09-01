//
//  RemoteGetListEvents.swift
//  Data
//
//  Created by Samuel Brehm on 01/09/21.
//

import Foundation
import Domain

public class RemoteGetListEvents {
    private let url: URL
    private let httpGetClient: HttpGetClient
    
    public init(url: URL, httpGetClient: HttpGetClient) {
        self.url = url
        self.httpGetClient = httpGetClient
    }
    
    public func getListEvents(completion: @escaping (DomainError) -> Void) {
        httpGetClient.get(to: url) { error in
            completion(.unexpected)
        }
    }
}
