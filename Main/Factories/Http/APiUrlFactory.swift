//
//  APiUrlFactory.swift
//  Main
//
//  Created by Samuel Brehm on 17/09/21.
//

import Foundation

final class APIUrlFactory {
    enum PathUrl: String {
        case events = "events"
        case checkin = "checkin"
    }
    
    static func makeApiBaseUrl(path: PathUrl) -> URL {
        let apiBaseUrl: String = "http://5f5a8f24d44d640016169133.mockapi.io/api/\(path)"
        return URL(string: apiBaseUrl)!
    }
}
