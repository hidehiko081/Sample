//
//  UserFavoriteRepositoryImpl.swift
//  GitHub
//
//  Created by Hikaru Sato on 2022/06/27.
//

import Foundation
import UIKit

struct UserFavoriteRepositoryImpl: UserFavoriteRepository {
    private let localDataSource: UserFavoriteLocalDataSource

    init(localDataSource: UserFavoriteLocalDataSource) {
        self.localDataSource = localDataSource
    }

    func saveFavorite(model: UserFavoriteModel) -> Result<Void, Error> {
        localDataSource.saveFavorite(model: model)
    }

    func getFavorite(userId: Int) -> Result<UserFavoriteModel?, Error> {
        localDataSource.getFavorite(userId: userId)
    }

    func getAllFavorites() -> Result<[UserFavoriteModel], Error> {
        localDataSource.getAllFavorites()
    }

    func deleteFavorite(userId: Int) -> Result<Void, Error> {
        localDataSource.deleteFavorite(userId: userId)
    }
}
