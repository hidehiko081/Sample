//
//  NewUsersRepositoryImpl.swift
//  GitHub
//
//  Created by Hikaru Sato on 2022/06/25.
//

import Foundation

struct NewUsersRepositoryImpl: NewUsersRepository {
    private let remoteDataSource: UsersRemoteDataSource

    init(remoteDataSource: UsersRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func requestUsers(userId: Int,
                      completionHandler:@escaping (_ models: [UserModel]) -> Void) {
        remoteDataSource.requestUsers(userId: userId, completionHandler: completionHandler)
    }
}
