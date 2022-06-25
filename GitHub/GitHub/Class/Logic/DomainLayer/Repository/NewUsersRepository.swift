//
//  NewUsersRepository.swift
//  GitHub
//
//  Created by Hikaru Sato on 2022/06/25.
//

import Foundation

protocol NewUsersRepository {
    func requestUsers(userId: Int,
                      completionHandler:@escaping (_ models: [UserModel]) -> Void)
}
