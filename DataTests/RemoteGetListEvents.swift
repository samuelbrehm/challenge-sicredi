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
    func test_getListEvents_should_call_httpClient_correct_url() throws {
        let url = URL(string: "http://any-url.com")!
        let (sut, httpGetClientSpy) = makeSut(url: url)
        sut.getListEvents()
        XCTAssertEqual(httpGetClientSpy.url, url)
    }
    
    func test_getListEvents_should_with_error_if_api_complete_with_error() throws {
        
    }
}

extension RemoteGetListEventsTests {
    func makeSut(url: URL = URL(string: "http://any-url.com")!) -> (sut: RemoteGetListEvents, HttpGetClientSpy: HttpGetClientSpy) {
        let httpGetClientSpy = HttpGetClientSpy()
        let sut = RemoteGetListEvents(url: url, httpGetClient: httpGetClientSpy)
        return (sut, httpGetClientSpy)
    }
    
    class HttpGetClientSpy: HttpGetClient {
        var url: URL?
        
        func get(url: URL) {
            self.url = url
        }
    }
}

