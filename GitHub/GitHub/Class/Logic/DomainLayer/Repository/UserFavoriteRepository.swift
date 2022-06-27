//
//  UserFavoriteRepository.swift
//  GitHub
//
//  Created by Hikaru Sato on 2022/06/27.
//

import Foundation

protocol UserFavoriteRepository {
    func saveFavorite(model: UserFavoriteModel) -> Result<Void, Error>
    func getFavorite(userId: Int) -> Result<UserFavoriteModel?, Error>
    func getAllFavorites() -> Result<[UserFavoriteModel], Error>
    func deleteFavorite(userId: Int) -> Result<Void, Error>
}
