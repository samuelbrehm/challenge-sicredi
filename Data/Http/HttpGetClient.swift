//
//  HttpGetClient.swift
//  Data
//
//  Created by Samuel Brehm on 01/09/21.
//

import Foundation

public protocol HttpGetClient {
    func get(to url: URL, with data: Data?, completion: @escaping (Result<Data?, HttpError>) -> Void)
}
