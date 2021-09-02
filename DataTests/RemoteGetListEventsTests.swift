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
    
    func test_getListEvents_should_complete_with_event_if_api_complete_with_data() throws {
        let (sut, httpGetClientSpy) = makeSut()
        let exp = expectation(description: "waiting")
        let expectedsEvent = makeEventModel() 
        sut.getListEvents() { result in
            switch result {
            case .failure(_): XCTFail("Expected success receive \(result) instead")
            case .success(let receivedEvent): XCTAssertEqual(receivedEvent, expectedsEvent)
            }
            
            exp.fulfill()
        }
        httpGetClientSpy.completeWithData(expectedsEvent.toData()!)
        wait(for: [exp], timeout: 1)
    }
}

extension RemoteGetListEventsTests {
    func makeSut(url: URL = URL(string: "http://any-url.com")!) -> (sut: RemoteGetListEvents, HttpGetClientSpy: HttpGetClientSpy) {
        let httpGetClientSpy = HttpGetClientSpy()
        let sut = RemoteGetListEvents(url: url, httpGetClient: httpGetClientSpy)
        return (sut, httpGetClientSpy)
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
        var completion: ((Result<Data, HttpError>) -> Void)?
        
        func get(to url: URL, completion: @escaping (Result<Data, HttpError>) -> Void) {
            self.url = url
            self.completion = completion
        }
        
        func completeWithError(_ error: HttpError) {
            completion?(.failure(error))
        }
        
        func completeWithData(_ data: Data) {
            completion?(.success(data))
        }
    }
}

