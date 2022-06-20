//
//  UserModel.swift
//  GitHub
//
//  Created by aihara hidehiko on 2022/04/29.
//

import Foundation

class UserModel {
    let login: String?
    let id: Int?
    let nodeId: String?
    let avatarUrl: String?
    let gravatarId: String?
    let url: String?
    let htmlUrl: String?
    let followersUrl: String?
    let followingUrl: String?
    let gistsUrl: String?
    let starredUrl: String?
    let subscriptionsUrl: String?
    let organizationsUrl: String?
    let reposUrl: String?
    let eventsUrl: String?
    let receivedEventsUrl: String?
    let type: String?
    let siteAdmin: Bool?
    
    init(login: String?,
         id: Int?,
         nodeId: String?,
         avatarUrl: String?,
         gravatarId: String?,
         url: String?,
         htmlUrl: String?,
         followersUrl: String?,
         followingUrl: String?,
         gistsUrl: String?,
         starredUrl: String?,
         subscriptionsUrl: String?,
         organizationsUrl: String?,
         reposUrl: String?,
         eventsUrl: String?,
         receivedEventsUrl: String?,
         type: String?,
         siteAdmin: Bool?) {
        self.login = login
        self.id = id
        self.nodeId = nodeId
        self.avatarUrl = avatarUrl
        self.gravatarId = gravatarId
        self.url = url
        self.htmlUrl = htmlUrl
        self.followersUrl = followersUrl
        self.followingUrl = followingUrl
        self.gistsUrl = gistsUrl
        self.starredUrl = starredUrl
        self.subscriptionsUrl = subscriptionsUrl
        self.organizationsUrl = organizationsUrl
        self.reposUrl = reposUrl
        self.eventsUrl = eventsUrl
        self.receivedEventsUrl = receivedEventsUrl
        self.type = type
        self.siteAdmin = siteAdmin
    }
}

enum FollowType: Int {
    case followers = 1
    case following = 2
    
    var toString: String {
        switch self {
        case FollowType.followers:
            return "Followers"
        case FollowType.following:
            return "Following"
        }
    }
    
    static func getType(index: Int) -> FollowType {
        switch index {
        case 1:
            return .followers
        default:
            return .following
        }
    }
}
