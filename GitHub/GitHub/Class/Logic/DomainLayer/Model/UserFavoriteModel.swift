//
//  UserFavoriteModel.swift
//  GitHub
//
//  Created by aihara hidehiko on 2022/04/29.
//

import Foundation

class UserFavoriteModel {
    let login: String?
    let userId: Int
    let avatarUrl: String?
    let name: String?
    
    init(login: String?,
         userId: Int,
         avatarUrl: String?,
         name: String?) {
        self.login = login
        self.userId = userId
        self.avatarUrl = avatarUrl
        self.name = name
    }
}
