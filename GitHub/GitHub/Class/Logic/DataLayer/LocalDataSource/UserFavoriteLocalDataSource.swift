//
//  UserFavoriteLocalDataSource.swift
//  GitHub
//
//  Created by Hikaru Sato on 2022/06/27.
//

import Foundation
import RealmSwift

protocol UserFavoriteLocalDataSource {
    func saveFavorite(model: UserFavoriteModel) -> Result<Void, Error>
    func getFavorite(userId: Int) -> Result<UserFavoriteModel?, Error>
    func getAllFavorites() -> Result<[UserFavoriteModel], Error>
    func deleteFavorite(userId: Int) -> Result<Void, Error>
}

struct UserFavoriteLocalDataSourceImpl: UserFavoriteLocalDataSource {

    func saveFavorite(model: UserFavoriteModel) -> Result<Void, Error> {
        do {
            let realm = try Realm()
            try realm.write() {
                let userFavoriteRealm = UserFavoriteRealm()
                UserFavoriteRealm.setPrimaryId(realm: userFavoriteRealm)
                userFavoriteRealm.login = model.login
                userFavoriteRealm.userId = model.userId
                userFavoriteRealm.avatarUrl = model.avatarUrl
                userFavoriteRealm.name = model.name

                realm.add(userFavoriteRealm)
            }

            return .success(())
        } catch {
            return .failure(error)
        }
    }

    func getFavorite(userId: Int) -> Result<UserFavoriteModel?, Error> {
        do {
            let realm = try Realm()
            guard let realmObject = realm.objects(UserFavoriteRealm.self).first(where: { $0.userId == userId
            }) else {
                return .success(nil)
            }

            return .success(UserFavoriteModel(realm: realmObject))
        } catch {
            return .failure(error)
        }
    }

    func getAllFavorites() -> Result<[UserFavoriteModel], Error> {
        do {
            let realm = try Realm()
            let models = realm.objects(UserFavoriteRealm.self).list.map { UserFavoriteModel(realm: $0) }
            return .success(Array(models))
        } catch {
            return .failure(error)
        }
    }

    func deleteFavorite(userId: Int) -> Result<Void, Error> {
        do {
            let realm = try Realm()
            guard let realmObject = realm.objects(UserFavoriteRealm.self).first(where: { $0.userId == userId
            }) else {
                return .success(())
            }

            try realm.write {
                realm.delete(realmObject)
            }

            return .success(())
        } catch {
            return .failure(error)
        }
    }
}

private extension UserFavoriteModel {
    init(realm: UserFavoriteRealm) {
        self.init(
            login: realm.login,
            userId: realm.userId,
            avatarUrl: realm.avatarUrl,
            name: realm.name
        )
    }
}
