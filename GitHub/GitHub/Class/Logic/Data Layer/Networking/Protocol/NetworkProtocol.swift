//
//  NetworkProtocol.swift
//  GitHub
//
//  Created by aihara hidehiko on 2022/04/29.
//

import Foundation
import UIKit

protocol NetworkProtocol {
    
}

struct NetworkProtocolImpl: NetworkProtocol {
    private let request: NetworkRequest = NetworkRequestImpl()

    /// 一覧
    func requestUsers(url: String,
                      parameters: [String: Any]?,
                      completionHandler:@escaping (_ models: [UserModel]?) -> Void) {
        request.request(url: url,
                        parameters: parameters,
                        completionHandler: { response in
            if let status = response.response?.statusCode {
                switch(status){
                case 200:
                    guard let data = response.data else {
                        return
                    }
                    let models = UsersTranslator().translate(data)
                    return completionHandler(models)
                    
                default:
                    print("error with response status: \(status)")
                    break
                }
            }
            
            return completionHandler(nil)
        })
    }
    
    /// 詳細
    func requestUserDetail(url: String,
                           parameters: [String: Any]?,
                           completionHandler:@escaping (_ model: UserDetailModel?) -> Void) {
        request.request(url: url,
                        parameters: parameters,
                        completionHandler: { response in
            if let status = response.response?.statusCode {
                switch(status){
                case 200:
                    guard let data = response.data else {
                        return
                    }
                    let models = UserDetailTranslator().translate(data)
                    return completionHandler(models)
                    
                default:
                    print("error with response status: \(status)")
                    break
                }
            }
            
            return completionHandler(nil)
        })
    }
    
    /// リポジトリ
    func requestUserRepository(url: String,
                               parameters: [String: Any]?,
                               completionHandler:@escaping (_ models: [UserRepositoryModel]?) -> Void) {
        request.request(url: url,
                        parameters: parameters,
                        completionHandler: { response in
            if let status = response.response?.statusCode {
                switch(status){
                case 200:
                    guard let data = response.data else {
                        return
                    }
                    let models = UserRepositoryTranslator().translate(data)
                    return completionHandler(models)
                    
                default:
                    print("error with response status: \(status)")
                    break
                }
            }
            
            return completionHandler(nil)
        })
    }
    
    /// 検索
    func requestSearchUsers(url: String,
                            parameters: [String: Any]?,
                            completionHandler:@escaping (_ models: [UserModel]?) -> Void) {
        request.request(url: url,
                        parameters: parameters,
                        completionHandler: { response in
            if let status = response.response?.statusCode {
                switch(status){
                case 200:
                    guard let data = response.data else {
                        return
                    }
                    let models = SearchUsersTranslator().translate(data)
                    return completionHandler(models)
                    
                default:
                    print("error with response status: \(status)")
                    break
                }
            }
            
            return completionHandler(nil)
        })
    }
}
