//
//  SearchUsersTranslator.swift
//  GitHub
//
//  Created by aihara hidehiko on 2022/04/30.
//

import Foundation

struct SearchUsersTranslator: Translator {
    func translate(_ data: Data) -> [UserModel] {
        let models = self.parse(data: data)
        return models
    }

    /// パース
    func parse(data: Data) -> [UserModel] {
        var models = [UserModel]()
        
        guard let json = try? JSONSerialization.jsonObject(with: data) as? Dictionary<String,Any> else {
            return models
        }
        
        guard let items = json["items"] as? Array<Dictionary<String,Any>> else {
            return models
        }
        
        for item in items {
            guard let model = self.parseUser(dic: item) else {
                continue
            }
            
            models.append(model)
        }
        
        return models
    }
    
    func parseUser(dic: Dictionary<String,Any>) -> UserModel? {
        let model = UserModel(login: dic["login"] as? String,
                              id: dic["id"] as? Int,
                              nodeId: dic["node_id"] as? String,
                              avatarUrl: dic["avatar_url"] as? String,
                              gravatarId: dic["gravatar_id"] as? String,
                              url: dic["url"] as? String,
                              htmlUrl: dic["html_url"] as? String,
                              followersUrl: dic["followers_url"] as? String,
                              followingUrl: dic["following_url"] as? String,
                              gistsUrl: dic["gists_url"] as? String,
                              starredUrl: dic["starred_url"] as? String,
                              subscriptionsUrl: dic["subscriptions_url"] as? String,
                              organizationsUrl: dic["organizations_url"] as? String,
                              reposUrl: dic["repos_url"] as? String,
                              eventsUrl: dic["events_url"] as? String,
                              receivedEventsUrl: dic["received_events_url"] as? String,
                              type: dic["type"] as? String,
                              siteAdmin: dic["site_admin"] as? Bool)
        return model
        
    }
}
