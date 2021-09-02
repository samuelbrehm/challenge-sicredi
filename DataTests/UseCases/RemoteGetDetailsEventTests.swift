//
//  RemoteGetDeatilsEventTests.swift
//  DataTests
//
//  Created by Samuel Brehm on 02/09/21.
//

import Foundation

import XCTest
import Domain
import Data

class RemoteGetDetailsEventTests: XCTestCase {
    func test_getDetailsEvent_should_call_httpClient_correct_url() throws {
        let url = makeURL()
        let (sut, httpGetClientSpy) = makeSut(url: url)
        sut.getDetailsEvent()
        XCTAssertEqual(httpGetClientSpy.url, url)
    }
}

extension RemoteGetDetailsEventTests {
    func makeSut(url: URL = makeURL(), file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteGetDetailsEvent, HttpGetClientSpy: HttpGetClientSpy) {
        let httpGetClientSpy = HttpGetClientSpy()
        let sut = RemoteGetDetailsEvent(url: url, httpGetClient: httpGetClientSpy)
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: httpGetClientSpy, file: file, line: line)
        return (sut, httpGetClientSpy)
    }
}


class RemoteGetDetailsEvent {
    private let url: URL
    private let httpGetClient: HttpGetClient
    
    public init(url: URL, httpGetClient: HttpGetClient) {
        self.url = url
        self.httpGetClient = httpGetClient
    }
    
    func getDetailsEvent() {
        httpGetClient.get(to: url, with: nil) { _ in }
    }
}


