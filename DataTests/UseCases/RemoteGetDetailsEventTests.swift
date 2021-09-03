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
        sut.getDetailsEvent(detailsEventParam: makeDetailsEventParam()) { _ in }
        XCTAssertEqual(httpGetClientSpy.url, url)
    }
    
    func test_getDetailsEvent_should_call_httpClient_correct_data_param() throws {
        let url = makeURL()
        let (sut, httpGetClientSpy) = makeSut(url: url)
        sut.getDetailsEvent(detailsEventParam: makeDetailsEventParam()) { _ in }
        XCTAssertEqual(httpGetClientSpy.data, makeDetailsEventParam().toData())
    }
    
    func test_getDetailsEvent_should_complete_with_error_if_api_complete_with_error() throws {
        let (sut, httpGetClientSpy) = makeSut()
        let exp = expectation(description: "waiting")
        sut.getDetailsEvent(detailsEventParam: makeDetailsEventParam()) { result in
            switch result {
            case .failure(let error): XCTAssertEqual(error, .unexpected)
            case .success(_): XCTFail("Expected error receive \(result) instead")
            }
            
            exp.fulfill()
        }
        httpGetClientSpy.completeWithErrorOne(.noConnectivity)
        wait(for: [exp], timeout: 1)
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
    
    func getDetailsEvent(detailsEventParam: DetailsEventParam, completion: @escaping (Result<EventModel, DomainError>) -> Void) {
        httpGetClient.getOne(to: url, with: detailsEventParam.toData()) { result in
            switch result {
            case .failure: completion(.failure(.unexpected))
            case .success(_): break
            }
        }
    }
}


