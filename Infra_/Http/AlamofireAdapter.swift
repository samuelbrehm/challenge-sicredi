//
//  AlamofireAdapter.swift
//  Infra_
//
//  Created by Samuel Brehm on 08/09/21.
//

import Foundation
import Data
import Alamofire

public class AlamofireAdapter: HttpGetClient, HttpPostClient {
    private let session: Session
    
    public init(session: Session = .default) {
        self.session = session
    }
    
    public func post(to url: URL, with data: Data?, completion: @escaping (Result<HttpStatusResponse, HttpError>) -> Void) {
        session.request(url, method: .post, parameters: data?.toJson()).response { response in
            guard let statusCode = response.response?.statusCode else {
                return completion(.failure(.noConnectivity))
            }
            switch response.result {
            case .failure: completion(.failure(.noConnectivity))
            case .success:
                switch statusCode {
                case 200...299:
                    completion(.success(.ok))
                case 401:
                    completion(.failure(.unauthorized))
                case 403:
                    completion(.failure(.forbidden))
                case 400...499:
                    completion(.failure(.badRequest))
                case 500...599:
                    completion(.failure(.serverError))
                default:
                    completion(.failure(.noConnectivity))
                }
            }
        }
    }
    
    public func get(to url: URL, with data: Data?, completion: @escaping (Result<Data?, HttpError>) -> Void) {
        session.request(url, method: .get, parameters: data?.toJson()).responseData { response in
            guard let statusCode = response.response?.statusCode else {
                return completion(.failure(.noConnectivity))
            }
            switch response.result {
            case .failure: completion(.failure(.noConnectivity))
            case .success(let data):
                switch statusCode {
                case 200...299:
                    completion(.success(data))
                case 401:
                    completion(.failure(.unauthorized))
                case 403:
                    completion(.failure(.forbidden))
                case 400...499:
                    completion(.failure(.badRequest))
                case 500...599:
                    completion(.failure(.serverError))
                default:
                    completion(.failure(.noConnectivity))
                }
            }
        }
    }
}
