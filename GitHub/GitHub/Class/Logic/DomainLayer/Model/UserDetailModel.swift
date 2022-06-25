//
//  UserDetailModel.swift
//  GitHub
//
//  Created by aihara hidehiko on 2022/04/29.
//

import Foundation

class UserDetailModel {
    let user: UserModel?
    
    let name: String?
    let company: String?
    let blog: String?
    let location: String?
    let email: String?
    let hireable: String?
    let bio: String?
    let twitterUsername: String?
    let publicRepos: Int?
    let publicGists: Int?
    let followers: Int?
    let following: Int?
    let createdAt: Date?
    let updatedAt: Date?
    
    init(user: UserModel?,
         name: String?,
         company: String?,
         blog: String?,
         location: String?,
         email: String?,
         hireable: String?,
         bio: String?,
         twitterUsername: String?,
         publicRepos: Int?,
         publicGists: Int?,
         followers: Int?,
         following: Int?,
         createdAt: Date?,
         updatedAt: Date?) {
        
        self.user = user
        self.name = name
        self.company = company
        self.blog = blog
        self.location = location
        self.email = email
        self.hireable = hireable
        self.bio = bio
        self.twitterUsername = twitterUsername
        self.publicRepos = publicRepos
        self.publicGists = publicGists
        self.followers = followers
        self.following = following
        self.createdAt = createdAt
        self.updatedAt = updatedAt 
    }
}
