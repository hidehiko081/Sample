//
//  UsersRemoteDataSource.swift
//  GitHub
//
//  Created by Hikaru Sato on 2022/06/25.
//

import Foundation

/// @mockable
protocol UsersRemoteDataSource {
    func requestUsers(userId: Int,
                      completionHandler:@escaping (_ models: [UserModel]) -> Void)
}

struct UsersRemoteDataSourceImpl: UsersRemoteDataSource {
    private let request: NetworkRequest

    init(request: NetworkRequest) {
        self.request = request
    }

    /// 一覧
    func requestUsers(userId: Int,
                      completionHandler:@escaping (_ models: [UserModel]) -> Void
    ) {
        guard let url = NetworkAPI.getUsers(since: userId).getUrl()?.absoluteString else {
            print("url is null")
            return
        }

        request.getRequestDecodable(url: url, parameters: [:]) { (response: Result<[UserModel], Error>) in
            switch(response) {
            case .success(let models):
                completionHandler(models)
            case .failure:
                break
            }
        }
    }
}
