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
    var completionList: ((Result<[Data], HttpError>) -> Void)?
    var completionOne: ((Result<Data, HttpError>) -> Void)?
    var data: Data?
    
    func getList(to url: URL, with data: Data?, completion: @escaping (Result<[Data], HttpError>) -> Void) {
        self.url = url
        self.completionList = completion
        self.data = data
    }

    func getOne(to url: URL, with data: Data?, completion: @escaping (Result<Data, HttpError>) -> Void) {
        self.url = url
        self.completionOne = completion
        self.data = data
    }
    
    func completeWithErrorList(_ error: HttpError) {
        completionList?(.failure(error))
    }
    
    func completeWithErrorOne(_ error: HttpError) {
        completionOne?(.failure(error))
    }
    
    func completeWithDataList(_ data: [Data]) {
        completionList?(.success(data))
    }
    
    func completeWithDataOne(_ data: Data) {
        completionOne?(.success(data))
    }
}
