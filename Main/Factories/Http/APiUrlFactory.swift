//
//  APiUrlFactory.swift
//  Main
//
//  Created by Samuel Brehm on 17/09/21.
//

import Foundation

func makeApiBaseUrl() -> URL {
    let apiBaseUrl: String = "http://5f5a8f24d44d640016169133.mockapi.io/api/events"
    return URL(string: apiBaseUrl)!
}
