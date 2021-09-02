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
        let url = URL(string: "http://any-url.com")!
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
        httpGetClientSpy.completeWithError(.noConnectivity)
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
        httpGetClientSpy.completeWithData(expectedsEventToData)
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
        httpGetClientSpy.completeWithData(expectedsEventToData)
        wait(for: [exp], timeout: 1)
    }
    
    func test_add_should_not_complete_if_sut_has_been_deallocated_memory() throws {
        let httpGetClientSpy = HttpGetClientSpy()
        let url: URL = URL(string: "http://any-url.com")!
        var sut: RemoteGetListEvents? = RemoteGetListEvents(url: url, httpGetClient: httpGetClientSpy)
        var resultExpected: Result<[EventModel], DomainError>?
        sut?.getListEvents() { resultExpected = $0}
        sut = nil
        httpGetClientSpy.completeWithError(.noConnectivity)
        XCTAssertNil(resultExpected)
    }
}

extension RemoteGetListEventsTests {
    func makeSut(url: URL = URL(string: "http://any-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteGetListEvents, HttpGetClientSpy: HttpGetClientSpy) {
        let httpGetClientSpy = HttpGetClientSpy()
        let sut = RemoteGetListEvents(url: url, httpGetClient: httpGetClientSpy)
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: httpGetClientSpy, file: file, line: line)
        return (sut, httpGetClientSpy)
    }
    
    func checkMemoryLeak(for instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, file: file, line: line)
        }
    }
    
    func makeEventModel() -> EventModel {
        var peoples: [PeopleModel] = []
        peoples.append(makePeopleModel())
        return EventModel(peoples: peoples, date: Date(), description: "any-description", image: "any-url-image", latitude: Double.zero, longitude: Double.zero, price: Double.zero, title: "any-title", id: "any-id")
        
    }
    
    func makePeopleModel() -> PeopleModel {
        return PeopleModel(id: "any-id", eventId: "any-eventId", name: "any-name", email: "any@email.com")
    }
    
    class HttpGetClientSpy: HttpGetClient {        
        var url: URL?
        var completion: ((Result<[Data], HttpError>) -> Void)?
        
        func get(to url: URL, completion: @escaping (Result<[Data], HttpError>) -> Void) {
            self.url = url
            self.completion = completion
        }
        
        func completeWithError(_ error: HttpError) {
            completion?(.failure(error))
        }
        
        func completeWithData(_ data: [Data]) {
            completion?(.success(data))
        }
    }
}

