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
            switch response.result {
            case .failure: completion(.failure(.noConnectivity))
            case .success: break
            }
        }
    }
}

class AlamofireAdapterGetTests: XCTestCase {
    
    func test_get_should_make_call_request_with_correct_url_and_method() throws {
        let url = makeURL()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [UrlProtocolStub.self]
        let session = Session(configuration: configuration)
        let sut = AlamofireAdapterGet(session: session)
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
        let url = makeURL()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [UrlProtocolStub.self]
        let session = Session(configuration: configuration)
        let sut = AlamofireAdapterGet(session: session)
        var expectedResult: HttpError?
        sut.get(to: url, with: makeValidData()) { result in
            if case let .failure(error) = result {
                expectedResult = error
            }
        }
        let exp = expectation(description: "waiting")
        UrlProtocolStub.observeRequest { request in
            XCTAssertNil(expectedResult)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
}

class UrlProtocolStub: URLProtocol {
    static var emit: ((URLRequest) -> Void)?
    
    static func observeRequest(completion: @escaping (URLRequest) -> Void) {
        UrlProtocolStub.emit = completion
    }
    
    open override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    open override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    open override func startLoading() {
        UrlProtocolStub.emit?(request)
    }

    open override func stopLoading() {
        
    }
}
