//
//  TestMemoryLeak.swift
//  DataTests
//
//  Created by Samuel Brehm on 02/09/21.
//

import Foundation
import XCTest

extension XCTestCase {
    func checkMemoryLeak(for instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, file: file, line: line)
        }
    }    
}

