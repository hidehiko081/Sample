//
//  NetworkRequest.swift
//  GitHub
//
//  Created by aihara hidehiko on 2022/04/29.
//

import Foundation
import Alamofire

protocol NetworkRequest {
    func request(url: String,
                 parameters: [String: Any]?,
                 completionHandler:@escaping (_ response: DataResponse<Optional<Data>, AFError>) -> Void)
    func getRequestDecodable<T: Decodable>(url: String,
                                           parameters: [String: Any]?,
                                           completionHandler:@escaping (_ response: Result<T, Error>) -> Void)
}


struct NetworkRequestImpl: NetworkRequest {
    private let decoder: JSONDecoder

    init () {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = jsonDecoder
    }

    func request(url: String,
                 parameters: [String: Any]?,
                 completionHandler:@escaping (_ response: DataResponse<Optional<Data>, AFError>) -> Void) {
        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type":"application/json"]).response { response in
            completionHandler(response)
        }
    }

    func getRequestDecodable<T: Decodable>(url: String,
                                           parameters: [String: Any]?,
                                           completionHandler:@escaping (_ response: Result<T, Error>) -> Void) {
        AF.request(
            url,
            method: .get,
            parameters: parameters,
            headers: ["Content-Type":"application/json"]
        ).responseDecodable(
            of: T.self,
            decoder: self.decoder
        ) { response in
            switch (response.result) {
            case .success(let data):
                completionHandler(.success(data))
            case .failure(let afError):
                print("error with response: \(afError.errorDescription ?? "unkown")")
                completionHandler(.failure(afError))
            }
        }
    }
}
