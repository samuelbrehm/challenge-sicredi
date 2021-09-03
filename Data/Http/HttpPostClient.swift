//
//  HttpPostClient.swift
//  Data
//
//  Created by Samuel Brehm on 03/09/21.
//

import Foundation

public protocol HttpPostClient {
    func post(to url: URL, with data: Data?, completion: @escaping (Result<HttpStatusResponse, HttpError>) -> Void)
}
