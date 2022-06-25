//
//  UsersViewController.swift
//  GitHub
//
//  Created by aihara hidehiko on 2022/04/29.
//

import Foundation
import UIKit

class UsersViewController: UIViewController {
    /// 検索
    private var searchController: UISearchController!
    /// テーブル
    @IBOutlet weak var tableView: UITableView!

    var presenter: UsersPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    }

    deinit {
        print("")
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
        presenter.request()
    }

    /// ユーザー情報取得
    private func getUser(index: Int) -> UserModel {
        self.presenter.getUser(index: index)
    }

    /// 戻るボタンセットアップ
    private func setupBackBarButton(title: String?) {
        let backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.title = title
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
}

//MARK: - UsersView
extension UsersViewController: UsersView {
    var isSearchControllerActived: Bool {
        self.searchController.isActive
    }

    func reloadData() {
        tableView.reloadData()
    }
}

//MARK: - UIScrollViewDelegate
extension UsersViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPosition = self.tableView.contentOffset.y + self.tableView.frame.size.height
        let threshold = self.tableView.contentSize.height - self.tableView.contentSize.height * 0.2
        
        if (currentPosition > threshold &&
            self.tableView.isDragging) {
            self.presenter.requestNextUsers()
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
        presenter.numberOfRowsInSection
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        45.0
    }

    /// セルの高さ
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
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
        self.presenter.updateSearchResults(text: searchController.searchBar.text)
    }
}

//MARK: - Action
extension UsersViewController {
    /// 読み込みボタンタップ時
    @objc func touchUpInsideReloadButton(_ sender: AnyObject) {
        self.presenter.touchUpInsideReloadButton()
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
