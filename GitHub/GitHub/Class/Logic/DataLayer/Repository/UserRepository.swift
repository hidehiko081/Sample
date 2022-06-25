//
//  UserRepository.swift
//  GitHub
//
//  Created by aihara hidehiko on 2022/04/29.
//

import Foundation

protocol UserRepository {
    func getFavorite(userId: Int) -> UserFavoriteModel?
    func getAllFavorite() -> [UserFavoriteModel]?
    func saveFavorite(model: UserFavoriteModel,
                      completionHandler:@escaping (_ result: Bool, _ model: UserFavoriteModel?) -> Void)
    func deleteFavorite(userId: Int,
                        completionHandler:@escaping (_ result: Bool) -> Void)
}

struct UserRepositoryImpl: UserRepository {
    private let userProtocol = UserProtocolImpl()
    
    /// お気に入り取得
    func getFavorite(userId: Int) -> UserFavoriteModel? {
        let filter = "userId = " + String(userId)
        
        guard let realm = self.userProtocol.getFavorite(filter: filter)?.first else {
            return nil
        }
        
        let model = UserFavoriteTranslator().translate(realm)
        return model
    }
    
    /// 全お気に入り取得
    func getAllFavorite() -> [UserFavoriteModel]? {
        guard let realms = self.userProtocol.getAllFavorite() else {
            return nil
        }
        
        var models = [UserFavoriteModel]()
        for realm in realms {
            let model = UserFavoriteTranslator().translate(realm)
            models.append(model)
        }
        
        return models
    }
    
    /// お気に入り保存
    func saveFavorite(model: UserFavoriteModel,
                      completionHandler:@escaping (_ result: Bool, _ model: UserFavoriteModel?) -> Void) {
        
        self.userProtocol.saveFavorite(model: model,
                                       completionHandler: {result, realm in
            if result {
                let model = UserFavoriteTranslator().translate(realm)
                completionHandler(result, model)
            } else {
                completionHandler(false, nil)
            }
        })
    }
    
    /// お気に入り削除
    func deleteFavorite(userId: Int,
                        completionHandler:@escaping (_ result: Bool) -> Void) {
        let filter = "userId = " + String(userId)
        
        guard let realm = self.userProtocol.getFavorite(filter: filter)?.first else {
            completionHandler(false)
            return
        }
        self.userProtocol.deleteFavorite(userFavoriteRealm: realm,
                                         completionHandler: completionHandler)
    }
}
