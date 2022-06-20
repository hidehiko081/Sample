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
}



struct NetworkRequestImpl: NetworkRequest {
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
}
