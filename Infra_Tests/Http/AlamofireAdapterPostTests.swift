//
//  AlamofireAdapterPostTests.swift
//  Infra_Tests
//
//  Created by Samuel Brehm on 08/09/21.
//

import Foundation

import XCTest
import Alamofire
import Data
import Infra_

class AlamofireAdapterPostTests: XCTestCase {
    private var configuration: URLSessionConfiguration = URLSessionConfiguration.default
    private var session: Session = Session()
    
    func test_post_should_make_call_request_with_correct_url_and_method() throws {
        let url = makeURL()
        let sut = makeSut()
        let exp = expectation(description: "waiting_post")
        sut.post(to: url, with: makeValidData()) { _ in }
        UrlProtocolStub.observeRequest { request in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("POST", request.httpMethod)
            XCTAssertNotNil(request.httpBodyStream)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
    func test_post_should_make_request_with_no_data() {
        let url = makeURL()
        let sut = makeSut()
        let exp = expectation(description: "waiting_post")
        sut.post(to: url, with: nil) { _ in }
        UrlProtocolStub.observeRequest { request in
            XCTAssertNil(request.httpBodyStream)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
    func test_post_should_complete_with_error_when_request_complete_with_error() throws {
        expectResult(.failure(.badRequest), when: (data: nil, response: nil, error: makeError()))
    }
    
    func test_post_should_complete_with_data_when_request_completes_with_200() {
        expectResult(.success(.ok), when: (data: makeValidData(), response: makeHttpResponse(), error: nil))
    }
}

extension AlamofireAdapterPostTests {
    func makeSut(file: StaticString = #filePath, line: UInt = #line) -> AlamofireAdapter {
        self.configuration.protocolClasses = [UrlProtocolStub.self]
        self.session = Session(configuration: configuration)
        let sut = AlamofireAdapter(session: session)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
    
    func testRequestFor(url: URL = makeURL(), data: Data?, action: @escaping (URLRequest) -> Void) {
        let sut = makeSut()
        let exp = expectation(description: "waiting_post")
        sut.post(to: url, with: data) { _ in exp.fulfill() }
        var request: URLRequest?
        UrlProtocolStub.observeRequest { request = $0 }
        wait(for: [exp], timeout: 1)
        action(request!)
    }
    
    func expectResult(_ expectedResult: Result<HttpStatusResponse, HttpError>, when stub: (data: Data?, response: HTTPURLResponse?, error: Error?), file: StaticString = #filePath, line: UInt = #line) {
        let sut = makeSut()
        UrlProtocolStub.simulate(data: stub.data, response: stub.response, error: stub.error)
        let exp = expectation(description: "waiting_expect_result")
        sut.post(to: makeURL(), with: makeValidData()) { receivedResult in
            switch (expectedResult, receivedResult) {
            case (.failure(let expectedError), .failure(let receivedError)): XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            case (.success(let expectedData), .success(let receivedData)): XCTAssertEqual(expectedData, receivedData, file: file, line: line)
            default: XCTFail("Expected \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
}
