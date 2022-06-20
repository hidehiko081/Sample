//
//  NetworkAPIConst.swift
//  GitHub
//
//  Created by aihara hidehiko on 2022/04/29.
//

import Foundation

struct NetworkAPIConst {
    static let host = "api.github.com"
}

enum NetworkAPI {
    case getUsers(since: Int)
    case getUserDetail(login: String)
    case getUserRepos(login: String, pageIndex: Int)
    case getFollowers(login: String, pageIndex: Int)
    case getFollowing(login: String, pageIndex: Int)
    case getSwstgMaster
    case getSearchUser(user: String, pageIndex: Int)
    
    func getUrl() -> URL? {
        var component = URLComponents()
        component.scheme = "https"
        component.host = NetworkAPIConst.host
        component.path = path
        component.queryItems = pageQuery()
        return component.url
    }
    
    
    private func pageQuery()-> [URLQueryItem]? {
        switch self {
        case .getUsers(let since):
            return [URLQueryItem(name: "since", value: String(since))]
        case .getUserDetail:
            return nil
        case .getUserRepos(_, let page):
            return [URLQueryItem(name: "page", value: String(page))]
        case .getFollowers(_, let page):
            return [URLQueryItem(name: "page", value: String(page))]
        case .getFollowing(_, let page):
            return [URLQueryItem(name: "page", value: String(page))]
        case .getSwstgMaster:
            return nil
        case .getSearchUser(let user, let page):
            return [URLQueryItem(name: "q", value: user),
                    URLQueryItem(name: "page", value: String(page))
            ]
        }
    }
}

extension NetworkAPI {
    fileprivate var path: String {
        switch self {
        case .getUsers:
            return "/users"
        case .getUserDetail(let login):
            return "/users/" + login
        case .getUserRepos(let login, _):
            return "/users/" + login + "/repos"
        case .getFollowers(let login, _):
            return "/users/" + login + "/followers"
        case .getFollowing(let login, _):
            return "/users/" + login + "/following"
        case .getSwstgMaster:
            return "/kawabou/file/files/master/obs/swstg/"
        case .getSearchUser:
            return "/search/users"
        }
    }
}

