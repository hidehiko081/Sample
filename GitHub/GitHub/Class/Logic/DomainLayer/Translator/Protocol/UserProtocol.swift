//
//  UserProtocol.swift
//  GitHub
//
//  Created by aihara hidehiko on 2022/04/29.
//

import Foundation
import RealmSwift

protocol UserProtocol {
    
}

class UserProtocolImpl: UserProtocol {
    
}


//MARK: - Init
extension UserProtocolImpl {
    
}

//MARK: - Save
extension UserProtocolImpl {
    func saveFavorite(model: UserFavoriteModel,
                      completionHandler:@escaping (_ result: Bool, _ realm: UserFavoriteRealm) -> Void) {
        let userFavoriteRealm = UserFavoriteRealm()
        UserFavoriteRealm.setPrimaryId(realm: userFavoriteRealm)
        
        let realm = try! Realm()
        try! realm.write() {
            userFavoriteRealm.login = model.login
            userFavoriteRealm.userId = model.userId
            userFavoriteRealm.avatarUrl = model.avatarUrl
            userFavoriteRealm.name = model.name
            
            realm.add(userFavoriteRealm)
            
            completionHandler(true, userFavoriteRealm)
        }
    }
}

//MARK: - Update
extension UserProtocolImpl {
    
}

//MARK: - Get
extension UserProtocolImpl {
    func getFavorite(filter: String) -> Results<UserFavoriteRealm>? {
        let realm = try! Realm()
        return realm.objects(UserFavoriteRealm.self).filter(filter)
    }
    
    func getAllFavorite() -> Results<UserFavoriteRealm>? {
        let realm = try! Realm()
        return realm.objects(UserFavoriteRealm.self)
    }
}


//MARK: - Delete
extension UserProtocolImpl {
    func deleteFavorite(userFavoriteRealm: UserFavoriteRealm,
                        completionHandler:@escaping (_ result: Bool) -> Void) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(userFavoriteRealm)
            completionHandler(true)
        }
    }
}

