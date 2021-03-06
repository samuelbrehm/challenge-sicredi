//
//  HttpError.swift
//  Data
//
//  Created by Samuel Brehm on 01/09/21.
//

import Foundation

public enum HttpError: Error {
    case noConnectivity
    case badRequest
    case serverError
    case unauthorized
    case forbidden
    case unexpected
}
