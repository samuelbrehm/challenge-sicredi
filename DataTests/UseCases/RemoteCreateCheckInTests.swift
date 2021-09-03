//
//  RemoteCreateCheckInTests.swift
//  DataTests
//
//  Created by Samuel Brehm on 03/09/21.
//

import Foundation

import Foundation

import XCTest
import Domain
import Data

class RemoteCreateChekInTests: XCTestCase {
    func test_addCheckIn_should_call_httpClient_with_correct_url() throws {
        let url = makeURL()
        let (sut, httpPostClientSpy) = makeSut(url: url)
        sut.addCheckIn()
        XCTAssertEqual(httpPostClientSpy.url, url)
    }
}

extension RemoteCreateChekInTests {
    func makeSut(url: URL = makeURL(), file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteCreateCheckIn, httpPostClientSpy: HttpPostClientSpy) {
        let httpPostClientSpy = HttpPostClientSpy()
        let sut = RemoteCreateCheckIn(httpPostClient: httpPostClientSpy, url: makeURL())
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: httpPostClientSpy, file: file, line: line)
        return (sut, httpPostClientSpy)
    }
    
    class HttpPostClientSpy: HttpPostClient {
        var url: URL?
        
        func post(to url: URL, with: Data?, completion: @escaping (Result<HttpStatusResponse, HttpError>) -> Void) {
            self.url = url
        }
        
        
    }
}

class RemoteCreateCheckIn {
    private let httpPostClient: HttpPostClient
    private let url: URL
    
    public init(httpPostClient: HttpPostClient, url: URL) {
        self.httpPostClient = httpPostClient
        self.url = url
    }
    
    func addCheckIn() {
        httpPostClient.post(to: url, with: nil) { _ in }
    }
}

protocol HttpPostClient {
    func post(to url: URL, with: Data?, completion: @escaping (Result<HttpStatusResponse, HttpError>) -> Void)
}

enum HttpStatusResponse {
    case ok
    case fail
}
