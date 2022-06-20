//
//  UserUseCase.swift
//  GitHub
//
//  Created by aihara hidehiko on 2022/04/29.
//

import Foundation

protocol UserUseCase {

}

struct UserUseCaseImpl: UserUseCase {
    private let repository: UserRepository = UserRepositoryImpl()
    
    func getFavorite(userId: Int) -> UserFavoriteModel? {
        return self.repository.getFavorite(userId: userId)
    }
    
    func getAllFavorite() -> [UserFavoriteModel]? {
        return self.repository.getAllFavorite()
    }
    
    func saveFavorite(model: UserFavoriteModel,
                      completionHandler:@escaping (_ result: Bool, _ model: UserFavoriteModel?) -> Void) {
        self.repository.saveFavorite(model: model,
                                     completionHandler: completionHandler)
    }
    
    func deleteFavorite(userId: Int,
                        completionHandler:@escaping (_ result: Bool) -> Void) {
        self.repository.deleteFavorite(userId: userId,
                                       completionHandler: completionHandler)
    }
}
