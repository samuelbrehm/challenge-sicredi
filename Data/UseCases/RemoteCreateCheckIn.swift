//
//  RemoteCreateCheckIn.swift
//  Data
//
//  Created by Samuel Brehm on 03/09/21.
//

import Foundation
import Domain

public class RemoteCreateCheckIn {
    private let httpPostClient: HttpPostClient
    private let url: URL
    
    public init(httpPostClient: HttpPostClient, url: URL) {
        self.httpPostClient = httpPostClient
        self.url = url
    }
    
    public func addCheckIn(addCheckInParam: AddCheckInParam) {
        httpPostClient.post(to: url, with: addCheckInParam.toData()) { _ in }
    }
}
