//
//  UsersPresenter.swift
//  GitHub
//
//  Created by Hikaru Sato on 2022/06/25.
//

import Foundation

protocol UsersView: AnyObject {
    var isSearchControllerActived: Bool { get }
    func reloadData()
}

protocol UsersPresenter {
    var numberOfRowsInSection: Int { get }
    var view: UsersView? { get }
    func request()
    func requestNextUsers()
    func getUser(index: Int) -> UserModel
    func updateSearchResults(text: String?)
    func touchUpInsideReloadButton()
}

class UsersPresenterImpl: UsersPresenter {
    private let usersRepository: NewUsersRepository
    /// 一覧
    private var userModels: [UserModel] = [UserModel]()
    private var showUserModels: [UserModel] = [UserModel]()
    /// 読み込み完了
    private var isLoading = false
    /// ユーザid
    private var userId = 0

    weak var view: UsersView?

    init(usersRepository: NewUsersRepository, view: UsersView?) {
        self.usersRepository = usersRepository
        self.view = view
    }

    var numberOfRowsInSection: Int {
        if isSearchControllerActived {
            return self.showUserModels.count
        } else {
            return self.userModels.count
        }
    }

    private var isSearchControllerActived: Bool {
        view?.isSearchControllerActived == true
    }

    init(usersRepository: NewUsersRepository) {
        self.usersRepository = usersRepository
    }

    func request() {
        self.request(userId: 0)
    }

    func requestNextUsers() {
        guard let id = userModels.last?.id else {
            return
        }

        request(userId: id)
    }

    func getUser(index: Int) -> UserModel {
        if isSearchControllerActived {
            return showUserModels[index]
        } else {
            return userModels[index]
        }
    }

    func updateSearchResults(text: String?) {
        if text?.isEmpty == true {
            self.showUserModels = self.userModels
        } else {
            self.showUserModels = self.userModels.filter { $0.login?.contains(text ?? "") ?? false }
        }
    }

    func touchUpInsideReloadButton() {
        self.userId = 0
        self.userModels.removeAll()
        self.showUserModels.removeAll()
        self.request()
    }

    private func request(userId: Int) {
        if isLoading {
            return
        }

        isLoading = true
        usersRepository.requestUsers(userId: userId) { [weak self] models in
            guard let self = self else {
                return
            }

            self.userId = userId
            self.userModels.append(contentsOf: models)
            self.view?.reloadData()
            self.isLoading = false
        }
    }
}
