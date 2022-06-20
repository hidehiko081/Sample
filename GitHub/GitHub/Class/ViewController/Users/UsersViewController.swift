//
//  UsersViewController.swift
//  GitHub
//
//  Created by aihara hidehiko on 2022/04/29.
//

import Foundation
import UIKit

class UsersViewController: UIViewController {
    /// プロトコル
    let networkProtocol = NetworkProtocolImpl()
    /// 一覧
    var userModels: [UserModel] = [UserModel]()
    var showUserModels: [UserModel] = [UserModel]()
    /// 読み込み完了
    var isLoading = false
    /// ユーザid
    var userId = 0
    /// 検索
    private var searchController: UISearchController!
    
    /// テーブル
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
}

//MARK: - Segue
extension UsersViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? UserDetailViewController {
            if let model = sender as? UserModel {
                viewController.model = model
            }
        }
    }
}

//MARK: - Private
extension UsersViewController {
    /// セットアップ
    private func setup() {
        self.setupNavigation()
        self.setupSearch()
        self.setupTableView()
        
        self.request()
    }
    
    /// ナビゲーションセットアップ
    private func setupNavigation() {
        self.navigationItem.title = "GitHub Users"
        
        let settingbutton = UIBarButtonItem.setupBarButton(image: UIImage(systemName: "gearshape.fill"),
                                                           delegate: self,
                                                           action: #selector(touchUpInsideSettingButton(_:)))
        self.navigationItem.leftBarButtonItem = settingbutton
        
        let searchbutton = UIBarButtonItem.setupBarButton(image: UIImage(systemName: "magnifyingglass"),
                                                          delegate: self,
                                                          action: #selector(touchUpInsideReloadButton(_:)))
        
        let favoritebutton = UIBarButtonItem.setupBarButton(image: UIImage(systemName: "pin.circle.fill"),
                                                            delegate: self,
                                                            action: #selector(touchUpInsideFavoriteButton(_:)))
        
        self.navigationItem.rightBarButtonItems = [searchbutton,favoritebutton]
    }
    
    /// 検索セットアップ
    private func setupSearch() {
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false

        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    /// テーブルセットアップ
    private func setupTableView() {
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.layoutMargins = UIEdgeInsets.zero
        
        let identifiers = [UserViewCell.identifier,
        ]
        
        for identifier in identifiers {
            self.tableView.register(
                UINib(nibName: identifier, bundle: Bundle.main),
                forCellReuseIdentifier: identifier)
        }
    }
    
    /// リクエスト
    private func request() {
        self.requestUser(userId: self.userId)
    }
    
    /// ユーザーリクエスト
    private func requestUser(userId: Int) {
        #if true
        guard let url = NetworkAPI.getUsers(since: userId).getUrl()?.absoluteString else {
            return
        }
        var parameters = Dictionary<String,Any>()
        #else
        let url = "https://api.github.com/users"
        var parameters = Dictionary<String,Any>()
        parameters["since"] = userId
        #endif
        
        self.networkProtocol.requestUsers(url: url,
                                          parameters: parameters,
                                          completionHandler: {[weak self] models in
            guard let models = models else {
                self?.isLoading = false
                return
            }
            self?.userId = userId
            self?.userModels.append(contentsOf: models)
            
            self?.tableView.reloadData()
            self?.isLoading = false
        })
    }
    
    /// ユーザー情報取得
    private func getUser(index: Int) -> UserModel {
        if self.searchController.isActive {
            let model = self.showUserModels[index]
            return model
        }
        
        let model = self.userModels[index]
        return model
    }
    
    /// 戻るボタンセットアップ
    private func setupBackBarButton(title: String?) {
        let backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.title = title
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
}

//MARK: - UIScrollViewDelegate
extension UsersViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPosition = self.tableView.contentOffset.y + self.tableView.frame.size.height
        let threshold = self.tableView.contentSize.height - self.tableView.contentSize.height * 0.2
        
        if (currentPosition > threshold &&
            self.tableView.isDragging && !self.isLoading) {
            
            self.isLoading = true
            
            if let id = self.userModels.last?.id {
                self.requestUser(userId: id)
            }
        }
    }
}

//MARK: - UITableViewDataSource
extension UsersViewController: UITableViewDataSource {
    /// セクション数を返す
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// セクション内のセル数を返す
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        if self.searchController.isActive {
            return self.showUserModels.count
        } else {
            return self.userModels.count
        }
    }
    
    /// セルの高さ
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    /// セルを返す
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: UserViewCell.identifier,
                                                    for: indexPath) as? UserViewCell {
            
            let model = self.getUser(index: indexPath.row)
            cell.setup(model: model)
            return cell
        }
        
        return UITableViewCell()
    }
}

//MARK: - UITableViewDelegate
extension UsersViewController: UITableViewDelegate {
    /// セルタップ時
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        self.tableView?.deselectRow(at: indexPath, animated: false)
        
        let model = self.getUser(index: indexPath.row)
        self.setupBackBarButton(title: self.navigationItem.title)
        self.performSegue(withIdentifier: UserDetailViewController.identifier,
                          sender: model)
    }
}

//MARK: - UISearchResultsUpdating
extension UsersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        if text.isEmpty {
            self.showUserModels = self.userModels
        } else {
            self.showUserModels = self.userModels.filter { $0.login?.contains(text) ?? false }
        }
        self.tableView.reloadData()
    }
}

//MARK: - Action
extension UsersViewController {
    /// 読み込みボタンタップ時
    @objc func touchUpInsideReloadButton(_ sender: AnyObject) {
        self.userId = 0
        self.userModels.removeAll()
        self.showUserModels.removeAll()
        self.request()
        
        self.setupBackBarButton(title: "")
        self.performSegue(withIdentifier: SearchViewController.identifier,
                          sender: nil)
    }
    
    /// お気に入りボタンタップ時
    @objc func touchUpInsideFavoriteButton(_ sender: AnyObject) {
        self.setupBackBarButton(title: self.navigationItem.title)
        self.performSegue(withIdentifier: FavoriteViewController.identifier,
                          sender: nil)
    }
    
    /// 設定ボタンタップ時
    @objc func touchUpInsideSettingButton(_ sender: AnyObject) {
        self.setupBackBarButton(title: self.navigationItem.title)
        self.performSegue(withIdentifier: SettingViewController.identifier,
                          sender: nil)
    }
}
