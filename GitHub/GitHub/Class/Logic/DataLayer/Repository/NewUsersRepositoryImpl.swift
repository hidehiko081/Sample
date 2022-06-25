//
//  NewUsersRepositoryImpl.swift
//  GitHub
//
//  Created by Hikaru Sato on 2022/06/25.
//

import Foundation

struct NewUsersRepositoryImpl {
    private let remoteDataSource: UsersRemoteDataSource

    func requestUsers(userId: Int,
                      completionHandler:@escaping (_ models: [UserModel]) -> Void) {
        remoteDataSource.requestUsers(userId: userId, completionHandler: completionHandler)
    }
}
