//
//  UsersPresenterImplTests.swift
//  GitHubTests
//
//  Created by Hikaru Sato on 2022/06/25.
//

import XCTest
@testable import GitHub

class UsersPresenterImplTests: XCTestCase {

    func testRequestAndRequestNextUsers() {
        var calledUserId: Int!
        var users = (0..<30).map { UserModel(id: $0) }
        let remoteDataSource = UsersRemoteDataSourceMock()
        remoteDataSource.requestUsersHandler = { userId, completionHandler in
            calledUserId = userId
            completionHandler(users)
        }
        let usersView = UsersViewProtocolMock()
        let presenter = UsersPresenterImpl(
            usersRepository: NewUsersRepositoryImpl(remoteDataSource: remoteDataSource),
            view: usersView
        )
        presenter.request()

        XCTAssertEqual(calledUserId, 0)
        XCTAssertEqual(usersView.reloadDataCallCount, 1)
        (0..<30).forEach { i in
            XCTAssertEqual(presenter.getUser(index: i).id, i)
        }

        users = (30..<60).map { UserModel(id: $0) }
        presenter.requestNextUsers()
        XCTAssertEqual(calledUserId, 29)
        XCTAssertEqual(usersView.reloadDataCallCount, 2)
        (0..<60).forEach { i in
            XCTAssertEqual(presenter.getUser(index: i).id, i)
        }
    }
}

extension UserModel {
    init(id: Int) {
        self.init(
            login: nil, id: id, nodeId: nil, avatarUrl: nil, gravatarId: nil,
            url: nil, htmlUrl: nil, followersUrl: nil, followingUrl: nil, gistsUrl: nil,
            starredUrl: nil, subscriptionsUrl: nil, organizationsUrl: nil, reposUrl: nil, eventsUrl: nil,
            receivedEventsUrl: nil, type: nil, siteAdmin: nil
        )
    }
}
