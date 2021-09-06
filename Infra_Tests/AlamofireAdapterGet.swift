//
//  Infra_Tests.swift
//  Infra_Tests
//
//  Created by Samuel Brehm on 05/09/21.
//

import XCTest
import Alamofire
import Data

class AlamofireAdapterGet {
    private let session: Session
    
    public init(session: Session) {
        self.session = session
    }
    
    func get(to url: URL, with data: Data?, completion: @escaping (Result<Data?, HttpError>) -> Void) {
        session.request(url, method: .get, parameters: data?.toJson()).responseData { response in
            guard let _ = response.response?.statusCode else {
                return completion(.failure(.noConnectivity))
            }
            switch response.result {
            case .failure: completion(.failure(.noConnectivity))
            case .success(let data): completion(.success(data))
            }
        }
    }
}

class AlamofireAdapterGetTests: XCTestCase {
    
    func test_get_should_make_call_request_with_correct_url_and_method() throws {
        let url = makeURL()
        let sut = makeSut()
        sut.get(to: url, with: nil) { _ in }
        let exp = expectation(description: "waiting")
        UrlProtocolStub.observeRequest { request in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("GET", request.httpMethod)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
    func test_get_should_make_call_request_with_correct_params() throws {
        let sut = makeSut()
        let url = "\(makeURL().absoluteString)?data=valid_data"
        let expectUrl: URL = URL(string: url)!
        sut.get(to: makeURL(), with: makeValidData()) { _ in }
        let exp = expectation(description: "waiting")
        UrlProtocolStub.observeRequest { request in
            XCTAssertEqual(request.url, expectUrl)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
    func test_get_should_complete_with_error_when_request_complete_with_error() throws {
        expectResult(.failure(.noConnectivity), when: (data: nil, response: nil, error: makeError()))
    }
    
    func test_get_should_complete_with_data_when_request_completes_with_200() {
        expectResult(.success(makeValidData()), when: (data: makeValidData(), response: makeHttpResponse(), error: nil))
    }
    
    func test_get_should_complete_with_error_on_all_invalid_cases() {
        expectResult(.failure(.noConnectivity), when: (data: makeValidData(), response: makeHttpResponse(), error: makeError()))
        expectResult(.failure(.noConnectivity), when: (data: makeValidData(), response: nil, error: makeError()))
        expectResult(.failure(.noConnectivity), when: (data: makeValidData(), response: nil, error: nil))
        expectResult(.failure(.noConnectivity), when: (data: nil, response: makeHttpResponse(), error: makeError()))
        expectResult(.failure(.noConnectivity), when: (data: nil, response: makeHttpResponse(), error: nil))
        expectResult(.failure(.noConnectivity), when: (data: nil, response: nil, error: nil))
    }
}

extension AlamofireAdapterGetTests {
    func makeSut(file: StaticString = #filePath, line: UInt = #line) -> AlamofireAdapterGet {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [UrlProtocolStub.self]
        let session = Session(configuration: configuration)
        let sut = AlamofireAdapterGet(session: session)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
    
    func expectResult(_ expectedResult: Result<Data?, HttpError>, when stub: (data: Data?, response: HTTPURLResponse?, error: Error?), file: StaticString = #filePath, line: UInt = #line) {
        let sut = makeSut()
        UrlProtocolStub.simulate(data: stub.data, response: stub.response, error: stub.error)
        let exp = expectation(description: "waiting")
        sut.get(to: makeURL(), with: makeValidData()) { receivedResult in
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

class UrlProtocolStub: URLProtocol {
    static var emit: ((URLRequest) -> Void)?
    static var data: Data?
    static var response: HTTPURLResponse?
    static var error: Error?
    
    static func observeRequest(completion: @escaping (URLRequest) -> Void) {
        UrlProtocolStub.emit = completion
    }
    
    static func simulate(data: Data?, response: HTTPURLResponse?, error: Error?) {
        UrlProtocolStub.data = data
        UrlProtocolStub.response = response
        UrlProtocolStub.error = error
    }
    
    open override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    open override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    open override func startLoading() {
        UrlProtocolStub.emit?(request)
        
        if let data = UrlProtocolStub.data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        if let response = UrlProtocolStub.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        if let error = UrlProtocolStub.error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }

    open override func stopLoading() {
        
    }
}
