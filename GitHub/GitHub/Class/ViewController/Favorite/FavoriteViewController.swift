//
//  FavoriteViewController.swift
//  GitHub
//
//  Created by aihara hidehiko on 2022/04/29.
//

import Foundation
import UIKit

class FavoriteViewController: UIViewController {
    /// ユースケース
    let userUseCase = UserUseCaseImpl()
    /// 一覧
    var userModels: [UserFavoriteModel] = [UserFavoriteModel]()
    /// 読み込み完了
    var isLoading = false
    /// ユーザid
    var userId = 0
    
    /// テーブル
    @IBOutlet weak var tableView: UITableView!
    /// no data
    @IBOutlet weak var nodataImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
}

//MARK: - Segue
extension FavoriteViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? UserDetailViewController {
            // TODO: presenterをセットする形にする
            viewController.favoriteRepository = UserFavoriteRepositoryImpl(localDataSource: UserFavoriteLocalDataSourceImpl())
            if let model = sender as? UserModel {
                viewController.model = model
            }
        }
    }
}

//MARK: - Private
extension FavoriteViewController {
    /// セットアップ
    private func setup() {
        self.setupNavigation()
        self.setupTableView()
        self.setupFavorite()
    }
    
    /// ナビゲーションセットアップ
    private func setupNavigation() {
        self.navigationItem.title = "Favorite"
    }
    
    /// テーブルセットアップ
    private func setupTableView() {
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.layoutMargins = UIEdgeInsets.zero
        
        let identifiers = [FavoriteViewCell.identifier,
        ]
        
        for identifier in identifiers {
            self.tableView.register(
                UINib(nibName: identifier, bundle: Bundle.main),
                forCellReuseIdentifier: identifier)
        }
    }
    
    /// お気に入りセットアップ
    private func setupFavorite() {
        guard let models = self.userUseCase.getAllFavorite() else {
            return
        }
        self.userModels.append(contentsOf: models)
        self.showNoData()
    }
    
    /// nodata表示
    private func showNoData() {
        self.nodataImageView.isHidden = self.userModels.count == 0 ? false : true
    }
}

//MARK: - UITableViewDataSource
extension FavoriteViewController: UITableViewDataSource {
    /// セクション数を返す
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// セクション内のセル数を返す
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.userModels.count
    }
    
    /// セルの高さ
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    /// セルを返す
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteViewCell.identifier,
                                                    for: indexPath) as? FavoriteViewCell {
            let model = self.userModels[indexPath.row]
            cell.setup(model: model)
            return cell
        }
        
        return UITableViewCell()
    }
}

//MARK: - UITableViewDelegate
extension FavoriteViewController: UITableViewDelegate {
    /// セルタップ時
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        self.tableView?.deselectRow(at: indexPath, animated: false)
        
        let model = self.userModels[indexPath.row]
        
        let userModel = UserModel(login: model.login,
                                  id: model.userId,
                                  nodeId: nil,
                                  avatarUrl: model.avatarUrl,
                                  gravatarId: nil,
                                  url: nil,
                                  htmlUrl: nil,
                                  followersUrl: nil,
                                  followingUrl: nil,
                                  gistsUrl: nil,
                                  starredUrl: nil,
                                  subscriptionsUrl: nil,
                                  organizationsUrl: nil,
                                  reposUrl: nil,
                                  eventsUrl: nil,
                                  receivedEventsUrl: nil,
                                  type: nil,
                                  siteAdmin: nil)
        
        
        self.performSegue(withIdentifier: UserDetailViewController.identifier,
                          sender: userModel)
    }
}
