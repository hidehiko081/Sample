//
//  UserDetailTranslator.swift
//  GitHub
//
//  Created by aihara hidehiko on 2022/04/29.
//

import Foundation

struct UserDetailTranslator: Translator {
    func translate(_ data: Data) -> UserDetailModel? {
        let models = self.parse(data: data)
        return models
    }

    /// パース
    func parse(data: Data) -> UserDetailModel? {
        guard let json = try? JSONSerialization.jsonObject(with: data) as? Dictionary<String,Any> else {
            return nil
        }
        
        guard let model = self.parseUserDetail(dic: json) else {
            return nil
        }
        
        return model
    }
    
    func parseUserDetail(dic: Dictionary<String,Any>) -> UserDetailModel? {
        let model = UserDetailModel(user: nil,
                                    name: dic["name"] as? String,
                                    company: dic["name"] as? String,
                                    blog: dic["blog"] as? String,
                                    location: dic["location"] as? String,
                                    email: dic["email"] as? String,
                                    hireable: dic["hireable"] as? String,
                                    bio: dic["bio"] as? String,
                                    twitterUsername: dic["twitter_username"] as? String,
                                    publicRepos: dic["public_repos"] as? Int,
                                    publicGists: dic["public_gists"] as? Int,
                                    followers: dic["followers"] as? Int,
                                    following: dic["following"] as? Int,
                                    createdAt: Utility.dateFromString(string: dic["created_at"] as? String,
                                                                      format: "yyyy-MM-dd'T'HH:mm:ssZZZZZ"),
                                    updatedAt: Utility.dateFromString(string: dic["updated_at"] as? String,
                                                                      format: "yyyy-MM-dd'T'HH:mm:ssZZZZZ"))
        return model
        
    }
}
