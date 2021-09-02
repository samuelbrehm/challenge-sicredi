//
//  HttpGetClientSpy.swift
//  DataTests
//
//  Created by Samuel Brehm on 02/09/21.
//

import Foundation
import Data

class HttpGetClientSpy: HttpGetClient {
    var url: URL?
    var completion: ((Result<[Data], HttpError>) -> Void)?
    
    func get(to url: URL, with data: Data?, completion: @escaping (Result<[Data], HttpError>) -> Void) {
        self.url = url
        self.completion = completion
    }
    
    func completeWithError(_ error: HttpError) {
        completion?(.failure(error))
    }
    
    func completeWithData(_ data: [Data]) {
        completion?(.success(data))
    }
}
