//
//  CreateCheckInIntegrationTests.swift
//  UseCasesIntegrationTests
//
//  Created by Samuel Brehm on 08/09/21.
//

import XCTest
import Data
import Infra_
import Domain

class CreateCheckInIntegrationTests: XCTestCase {
    func test_create_checkin_events() throws {
        let alamofireAdapter = AlamofireAdapter()
        let url: URL = URL(string: "http://5f5a8f24d44d640016169133.mockapi.io/api/checkin")!
        let sut = RemoteCreateCheckIn(httpPostClient: alamofireAdapter, url: url)
        let exp = expectation(description: "waiting_create_checkin")
        let addCheckInParam = AddCheckInParam(eventId: "1", name: "Samuel", email: "samuelbrehm@gmail.com")
        sut.addCheckIn(addCheckInParam: addCheckInParam) { result in
            switch result {
            case .failure:
                XCTFail("Expected success got \(result) instead")
            case .success(let res):
                XCTAssertEqual(res, .success)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 6)
    }
}
