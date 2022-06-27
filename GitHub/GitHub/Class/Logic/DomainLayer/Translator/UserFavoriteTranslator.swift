//
//  UserFavoriteTranslator.swift
//  GitHub
//
//  Created by aihara hidehiko on 2022/04/29.
//

import Foundation
import RealmSwift

struct UserFavoriteTranslator: Translator {
    func translate(_ realm: UserFavoriteRealm) -> UserFavoriteModel {
        let model = UserFavoriteModel(id: realm.getPrimaryID(),
                                      login: realm.login,
                                      userId: realm.userId,
                                      avatarUrl: realm.avatarUrl,
                                      name: realm.name)
        return model
    }

}
