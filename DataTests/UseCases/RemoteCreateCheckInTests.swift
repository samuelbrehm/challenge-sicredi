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
        sut.addCheckIn(addCheckInParam: makeAddCheckInParam())
        XCTAssertEqual(httpPostClientSpy.url, url)
    }
    
    func test_addCheckIn_should_call_httpClient_correct_data_param() throws {
        let (sut, httpGetClientSpy) = makeSut()
        sut.addCheckIn(addCheckInParam: makeAddCheckInParam())
        XCTAssertEqual(httpGetClientSpy.data, makeAddCheckInParam().toData())
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
        var data: Data?
        
        func post(to url: URL, with data: Data?, completion: @escaping (Result<HttpStatusResponse, HttpError>) -> Void) {
            self.url = url
            self.data = data
        }
        
        
    }
}

