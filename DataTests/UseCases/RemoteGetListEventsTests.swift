//
//  DataTests.swift
//  DataTests
//
//  Created by Samuel Brehm on 01/09/21.
//

import XCTest
import Domain
import Data

class RemoteGetListEventsTests: XCTestCase {
    func test_getListEvents_should_call_httpClient_correct_url() throws {
        let url = makeURL()
        let (sut, httpGetClientSpy) = makeSut(url: url)
        sut.getListEvents() { _ in }
        XCTAssertEqual(httpGetClientSpy.url, url)
    }
    
    func test_getListEvents_should_complete_with_error_if_api_complete_with_error() throws {
        let (sut, httpGetClientSpy) = makeSut()
        let exp = expectation(description: "waiting")
        sut.getListEvents() { result in
            switch result {
            case .failure(let error): XCTAssertEqual(error, .unexpected)
            case .success(_): XCTFail("Expected error receive \(result) instead")
            }
            
            exp.fulfill()
        }
        httpGetClientSpy.completeWithErrorList(.noConnectivity)
        wait(for: [exp], timeout: 1)
    }
    
    func test_getListEvents_should_complete_with_array_event_if_api_complete_with_data() throws {
        let (sut, httpGetClientSpy) = makeSut()
        let exp = expectation(description: "waiting")
        let expectedsEvent: [EventModel] = [makeEventModel(), makeEventModel()]
        sut.getListEvents() { result in
            switch result {
            case .failure(_): XCTFail("Expected success receive \(result) instead")
            case .success(let receivedEvent): XCTAssertEqual(receivedEvent, expectedsEvent)
            }
            
            exp.fulfill()
        }
        let expectedsEventToData = expectedsEvent.compactMap({ $0.toData() })
        httpGetClientSpy.completeWithDataList(expectedsEventToData)
        wait(for: [exp], timeout: 1)
    }
    
    func test_getListEvents_should_complete_with_empty_array_if_api_complete_with_empty_data() throws {
        let (sut, httpGetClientSpy) = makeSut()
        let exp = expectation(description: "waiting")
        let expectedsEvent: [EventModel] = []
        sut.getListEvents() { result in
            switch result {
            case .failure(_): XCTFail("Expected success receive \(result) instead")
            case .success(let receivedEvent): XCTAssertEqual(receivedEvent, expectedsEvent)
            }
            
            exp.fulfill()
        }
        let expectedsEventToData = expectedsEvent.compactMap({ $0.toData() })
        httpGetClientSpy.completeWithDataList(expectedsEventToData)
        wait(for: [exp], timeout: 1)
    }
    
    func test_getListEvents_should_not_complete_if_sut_has_been_deallocated_memory() throws {
        let httpGetClientSpy = HttpGetClientSpy()
        let url: URL = makeURL()
        var sut: RemoteGetListEvents? = RemoteGetListEvents(url: url, httpGetClient: httpGetClientSpy)
        var resultExpected: Result<[EventModel], DomainError>?
        sut?.getListEvents() { resultExpected = $0}
        sut = nil
        httpGetClientSpy.completeWithErrorList(.noConnectivity)
        XCTAssertNil(resultExpected)
    }
}

extension RemoteGetListEventsTests {
    func makeSut(url: URL = makeURL(), file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteGetListEvents, HttpGetClientSpy: HttpGetClientSpy) {
        let httpGetClientSpy = HttpGetClientSpy()
        let sut = RemoteGetListEvents(url: url, httpGetClient: httpGetClientSpy)
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: httpGetClientSpy, file: file, line: line)
        return (sut, httpGetClientSpy)
    }
}

