//
//  RemoteCreateCheckIn.swift
//  Data
//
//  Created by Samuel Brehm on 03/09/21.
//

import Foundation
import Domain

public class RemoteCreateCheckIn: CreateCheckIn {
    private let httpPostClient: HttpPostClient
    private let url: URL
    
    public init(httpPostClient: HttpPostClient, url: URL) {
        self.httpPostClient = httpPostClient
        self.url = url
    }
    
    public func addCheckIn(addCheckInParam: AddCheckInParam, completion: @escaping (Result<StatusResponse, DomainError>) -> Void) {
        httpPostClient.post(to: url, with: addCheckInParam.toData()) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .failure: completion(.failure(.unexpected))
            case .success(_): completion(.success(.success))
            }
        }
    }
}
