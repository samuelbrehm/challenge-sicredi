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
        let url = makeURL().appendingPathComponent("/")
        let (sut, httpGetClientSpy) = makeSut(url: url)
        sut.getDetailsEvent(idEvent: "") { _ in }
        XCTAssertEqual(httpGetClientSpy.url, url)
    }
    
    func test_getDetailsEvent_should_call_httpClient_correct_url_with_idEvent_param() throws {
        let url = makeURL()
        let (sut, httpGetClientSpy) = makeSut(url: makeURL())
        let idEventTest: String = "any-id"
        sut.getDetailsEvent(idEvent: idEventTest) { _ in }
        let expectURL: URL = url.appendingPathComponent(idEventTest)
        XCTAssertEqual(httpGetClientSpy.url, expectURL)
    }
    
    func test_getDetailsEvent_should_complete_with_error_if_api_complete_with_error() throws {
        let (sut, httpGetClientSpy) = makeSut()
        let exp = expectation(description: "waiting")
        sut.getDetailsEvent(idEvent: "") { result in
            switch result {
            case .failure(let error): XCTAssertEqual(error, .unexpected)
            case .success(_): XCTFail("Expected error receive \(result) instead")
            }
            
            exp.fulfill()
        }
        httpGetClientSpy.completeWithError(.noConnectivity)
        wait(for: [exp], timeout: 1)
    }
    
    func test_getDetailsEvent_should_complete_with_event_if_api_complete_with_data() throws {
        let (sut, httpGetClientSpy) = makeSut()
        let exp = expectation(description: "waiting")
        let expectedEvent: EventModel = makeEventModel()
        sut.getDetailsEvent(idEvent: "") { result in
            switch result {
            case .failure(_): XCTFail("Expected success receive \(result) instead")
            case .success(let receivedEvent): XCTAssertEqual(receivedEvent, expectedEvent)
            }
            exp.fulfill()
        }
        httpGetClientSpy.completeWithData(expectedEvent.toData()!)
        wait(for: [exp], timeout: 1)
    }
    
    func test_getDetailsEvent_should_not_complete_if_sut_has_been_deallocated_memory() throws {
        let httpGetClientSpy = HttpGetClientSpy()
        let url: URL = makeURL()
        var sut: RemoteGetDetailsEvent? = RemoteGetDetailsEvent(url: url, httpGetClient: httpGetClientSpy)
        var resultExpected: Result<EventModel, DomainError>?
        sut?.getDetailsEvent(idEvent: "") { resultExpected = $0}
        sut = nil
        httpGetClientSpy.completeWithError(.noConnectivity)
        XCTAssertNil(resultExpected)
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


