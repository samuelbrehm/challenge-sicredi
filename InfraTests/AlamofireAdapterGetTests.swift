//
//  InfraTests.swift
//  InfraTests
//
//  Created by Samuel Brehm on 03/09/21.
//

import XCTest
import Alamofire

class AlamofireAdapterGet {
    private let session: Session
    
    public init(session: Session) {
        self.session = session
    }
    
    func getOne(to url: URL) {
        session.request(url, method: .get).resume()
    }
}

class AlamofireAdapterGetTests: XCTestCase {
    
    func test_() throws {
        let url = makeURL()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [UrlProtocolStub.self]
        let session = Session(configuration: configuration)
        let sut = AlamofireAdapterGet(session: session)
        sut.getOne(to: url)
        let exp = expectation(description: "waiting")
        UrlProtocolStub.observeRequest { request in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("GET", request.httpMethod)
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
