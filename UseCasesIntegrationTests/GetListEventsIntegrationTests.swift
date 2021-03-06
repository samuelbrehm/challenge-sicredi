//
//  UseCasesIntegrationTests.swift
//  UseCasesIntegrationTests
//
//  Created by Samuel Brehm on 08/09/21.
//

import XCTest
import Data
import Infra_

class GetListEventsIntegrationTests: XCTestCase {
    func test_get_list_events() throws {
        let alamofireAdapter = AlamofireAdapter()
        let url: URL = URL(string: "http://5f5a8f24d44d640016169133.mockapi.io/api/events")!
        let sut = RemoteGetListEvents(url: url, httpGetClient: alamofireAdapter)
        let exp = expectation(description: "waiting_list_events")
        sut.getListEvents { result in
            switch result {
            case .failure: XCTFail("Expect success result got \(result) instead")
            case .success(let listEvents):
                XCTAssertGreaterThanOrEqual(listEvents.count, 1)
                XCTAssertEqual(listEvents.count, 5)
                XCTAssertEqual(listEvents[0].id, "1")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 6)
    }
}
