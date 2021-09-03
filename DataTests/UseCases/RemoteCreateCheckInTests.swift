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
        sut.addCheckIn(addCheckInParam: makeAddCheckInParam()) { _ in}
        XCTAssertEqual(httpPostClientSpy.url, url)
    }
    
    func test_addCheckIn_should_call_httpClient_correct_data_param() throws {
        let (sut, httpPostClientSpy) = makeSut()
        sut.addCheckIn(addCheckInParam: makeAddCheckInParam()) { _ in }
        XCTAssertEqual(httpPostClientSpy.data, makeAddCheckInParam().toData())
    }
    
    func test_addCheckIn_should_complete_with_error_if_api_complete_with_error() throws {
        let (sut, httpPostClientSpy) = makeSut()
        let exp = expectation(description: "waiting")
        sut.addCheckIn(addCheckInParam: makeAddCheckInParam()) { result in
            switch result {
            case .failure(let error): XCTAssertEqual(error, .unexpected)
            case .success(_): XCTFail("Expected error receive \(result) instead")
            }
            
            exp.fulfill()
        }
        httpPostClientSpy.completeWithError(.noConnectivity)
        wait(for: [exp], timeout: 1)
    }
    
    func test_addCheckIn_should_complete_with_status_ok_if_api_complete_with_success() throws {
        let (sut, httpPostClientSpy) = makeSut()
        let exp = expectation(description: "waiting")
        sut.addCheckIn(addCheckInParam: makeAddCheckInParam()) { result in
            switch result {
            case .failure(_): XCTFail("Expected success receive \(result) instead")
            case .success(let statusResponse): XCTAssertEqual(statusResponse, .success)
            }
            
            exp.fulfill()
        }
        httpPostClientSpy.completeWithSuccess(.ok)
        wait(for: [exp], timeout: 1)
    }
    
    func test_addCheckIn_should_not_complete_if_sut_has_been_deallocated_memory() throws {
        let httpPostClientSpy = HttpPostClientSpy()
        var sut: RemoteCreateCheckIn? = RemoteCreateCheckIn(httpPostClient: httpPostClientSpy, url: makeURL())
        var resultExpected: Result<StatusResponse, DomainError>?
        sut?.addCheckIn(addCheckInParam: makeAddCheckInParam()) { resultExpected = $0}
        sut = nil
        httpPostClientSpy.completeWithError(.noConnectivity)
        XCTAssertNil(resultExpected)
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
        var completion: ((Result<HttpStatusResponse, HttpError>) -> Void)?
        
        func post(to url: URL, with data: Data?, completion: @escaping (Result<HttpStatusResponse, HttpError>) -> Void) {
            self.url = url
            self.data = data
            self.completion = completion
        }
        
        func completeWithError(_ error: HttpError) {
            completion?(.failure(error))
        }
        
        func completeWithSuccess(_ httpStatusResponse: HttpStatusResponse) {
            completion?(.success(httpStatusResponse))
        }
        
    }
}

