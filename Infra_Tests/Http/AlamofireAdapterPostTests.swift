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
}

extension AlamofireAdapterPostTests {
    func makeSut(file: StaticString = #filePath, line: UInt = #line) -> AlamofireAdapter {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [UrlProtocolStub.self]
        let session = Session(configuration: configuration)
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
}
