//
//  UserFavoriteRealm.swift
//  GitHub
//
//  Created by aihara hidehiko on 2022/04/29.
//

import Foundation
import RealmSwift


class UserFavoriteRealm: Object {
    static let realm = try! Realm()
    /// プライマリーID
    @objc dynamic fileprivate var id = 0
    
    @objc dynamic var login: String?
    @objc dynamic var userId: Int = 0
    @objc dynamic var avatarUrl: String?
    @objc dynamic var name: String?
    
    
    /// プライマリーID
    override static func primaryKey() -> String? {
        return "id"
    }
    
    /// 最終ID
    static func lastId() -> Int {
        let idInt = realm.objects(UserFavoriteRealm.self).max(ofProperty: "id") as Int?
        
        if let lastID = idInt {
            return lastID + 1
        }
        return 2
    }
    
    /// ID取得
    func getPrimaryID() -> Int {
        return self.id
    }
    
    /// IDをセット
    class func setPrimaryId(realm: UserFavoriteRealm) {
        realm.id = UserFavoriteRealm.lastId()
    }
}
