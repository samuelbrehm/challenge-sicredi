//
//  DataTests.swift
//  DataTests
//
//  Created by Samuel Brehm on 01/09/21.
//

import XCTest

class RemoteGetListEvents {
    private let url: URL
    private let httpGetClient: HttpGetClient
    
    init(url: URL, httpGetClient: HttpGetClient) {
        self.url = url
        self.httpGetClient = httpGetClient
    }
    
    func getListEvents() {
        httpGetClient.get(url: url)
    }
}

protocol HttpGetClient {
    func get(url: URL)
}

class RemoteGetListEventsTests: XCTestCase {
    func test_() throws {
        let url = URL(string: "http://any-url.com")!
        let httpGetClientSpy = HttpGetClientSpy()
        let sut = RemoteGetListEvents(url: url, httpGetClient: httpGetClientSpy)
        sut.getListEvents()
        XCTAssertEqual(httpGetClientSpy.url, url)
    }
}

class HttpGetClientSpy: HttpGetClient {
    var url: URL?
    
    func get(url: URL) {
        self.url = url
    }
}
