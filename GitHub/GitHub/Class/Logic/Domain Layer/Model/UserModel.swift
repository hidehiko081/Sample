//
//  UserModel.swift
//  GitHub
//
//  Created by aihara hidehiko on 2022/04/29.
//

import Foundation

struct UserModel: Decodable {
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
