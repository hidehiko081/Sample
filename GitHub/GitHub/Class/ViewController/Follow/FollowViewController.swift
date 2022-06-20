//
//  FollowViewController.swift
//  GitHub
//
//  Created by aihara hidehiko on 2022/04/29.
//

import Foundation
import UIKit

class FollowViewController: UIViewController {
    /// プロトコル
    let networkProtocol = NetworkProtocolImpl()
    /// フォロータイプ
    var type: FollowType = .followers
    /// ユーザー
    var userModel: UserModel?
    /// 一覧
    var userModels: [UserModel] = [UserModel]()
    /// 読み込み完了
    var isLoading = false
    /// ページ数
    var displayPage = 1
    
    /// テーブル
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
}

//MARK: - Segue
extension FollowViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? UserDetailViewController {
            if let model = sender as? UserModel {
                viewController.model = model
            }
        }
    }
}

//MARK: - Private
extension FollowViewController {
    /// セットアップ
    private func setup() {
        self.setupNavigation()
        self.setupTableView()
        self.request()
    }
    
    /// ナビゲーションセットアップ
    private func setupNavigation() {
        self.navigationItem.title = self.type.toString
    }
    
    /// テーブルセットアップ
    private func setupTableView() {
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.layoutMargins = UIEdgeInsets.zero
        
        let identifiers = [FollowViewCell.identifier,
        ]
        
        for identifier in identifiers {
            self.tableView.register(
                UINib(nibName: identifier, bundle: Bundle.main),
                forCellReuseIdentifier: identifier)
        }
    }
    
    /// リクエスト
    private func request() {
        self.requestUser(page: self.displayPage)
    }
    
    /// ユーザーリクエスト
    private func requestUser(page: Int) {
        guard let url = self.getRequestUrl(page: page) else {
            return
        }
        self.networkProtocol.requestUsers(url: url,
                                          parameters: nil,
                                          completionHandler: {[weak self] models in
            guard let models = models else {
                self?.isLoading = false
                return
            }
            self?.displayPage = page
            self?.userModels.append(contentsOf: models)
            
            self?.tableView.reloadData()
            self?.isLoading = false
        })
    }
    
    /// リクエストurl
    private func getRequestUrl(page: Int) -> String? {
        guard let login = self.userModel?.login else {
            return nil
        }
        
        switch self.type {
        case .followers:
            guard let url = NetworkAPI.getFollowers(login: login,
                                                    pageIndex: page).getUrl()?.absoluteString else {
                return nil
            }
            return url
            
        case .following:
            guard let url = NetworkAPI.getFollowing(login: login,
                                                    pageIndex: page).getUrl()?.absoluteString else {
                return nil
            }
            return url
        }
    }
}

//MARK: - UIScrollViewDelegate
extension FollowViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPosition = self.tableView.contentOffset.y + self.tableView.frame.size.height
        let threshold = self.tableView.contentSize.height - self.tableView.contentSize.height * 0.2
        
        if (currentPosition > threshold &&
            self.tableView.isDragging && !self.isLoading) {
            
            self.isLoading = true
            
            self.requestUser(page: self.displayPage + 1)
        }
    }
}

//MARK: - UITableViewDataSource
extension FollowViewController: UITableViewDataSource {
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: FollowViewCell.identifier,
                                                    for: indexPath) as? FollowViewCell {
            let model = self.userModels[indexPath.row]
            cell.setup(model: model)
            return cell
        }
        
        return UITableViewCell()
    }
}

//MARK: - UITableViewDelegate
extension FollowViewController: UITableViewDelegate {
    /// セルタップ時
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        self.tableView?.deselectRow(at: indexPath, animated: false)
        
        let model = self.userModels[indexPath.row]
        self.performSegue(withIdentifier: UserDetailViewController.identifier,
                          sender: model)
    }
}
