//
//  SearchViewController.swift
//  GitHub
//
//  Created by aihara hidehiko on 2022/04/30.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    /// プロトコル
    let networkProtocol = NetworkProtocolImpl()
    /// 一覧
    var userModels: [UserModel] = [UserModel]()
    var showUserModels: [UserModel] = [UserModel]()
    /// 読み込み完了
    var isLoading = false
    /// サーチバー
    var searchBar: UISearchBar!
    /// ページ数
    var displayPage = 1
    /// 検索ワード
    var searchWord: String?
    
    
    /// テーブル
    @IBOutlet weak var tableView: UITableView!
    /// no data
    @IBOutlet weak var nodataImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchBar.becomeFirstResponder()
    }
}


//MARK: - Segue
extension SearchViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? UserDetailViewController {
            if let model = sender as? UserModel {
                viewController.model = model
            }
        }
    }
}

//MARK: - Private
extension SearchViewController {
    /// セットアップ
    private func setup() {
        self.setupNavigation()
        self.setupNotification()
        self.setupSearchBar()
        self.setupTableView()
    }
    
    /// ナビゲーションセットアップ
    private func setupNavigation() {
        self.navigationItem.title = "Search"
    }
    
    /// 検索セットアップ
    func setupSearchBar() {
        guard let navigationBarFrame = navigationController?.navigationBar.bounds else {
            return
        }
        
        let searchBar: UISearchBar = UISearchBar(frame: navigationBarFrame)
        searchBar.delegate = self
        searchBar.placeholder = "login search"
        searchBar.tintColor = UIColor.gray
        searchBar.keyboardType = UIKeyboardType.default
        navigationItem.titleView = searchBar
        navigationItem.titleView?.frame = searchBar.frame
        self.searchBar = searchBar
    }
    
    /// テーブルセットアップ
    private func setupTableView() {
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.layoutMargins = UIEdgeInsets.zero
        
        let identifiers = [SearchViewCell.identifier,
        ]
        
        for identifier in identifiers {
            self.tableView.register(
                UINib(nibName: identifier, bundle: Bundle.main),
                forCellReuseIdentifier: identifier)
        }
    }
    
    /// 通知セットアップ
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    /// リクエスト
    private func request() {
        self.requestSearch(page: self.displayPage)
    }
    
    
    /// リポジトリリクエスト
    private func requestSearch(page: Int) {
        guard let text = self.searchBar.text else {
            return
        }
        let user = text + "+in:login"
        
        var page = page
        
        if self.searchWord != text {
            page = 1
            self.userModels.removeAll()
            self.tableView.reloadData()
        }
        
        self.searchWord = text
        
        
        guard let url = NetworkAPI.getSearchUser(user: user, pageIndex: page).getUrl()?.absoluteString else {
            return
        }
        
        self.networkProtocol.requestSearchUsers(url: url,
                                                parameters: nil,
                                                completionHandler: {[weak self] models in
            guard let models = models else {
                self?.showNoData()
                self?.isLoading = false
                return
            }
            
            self?.displayPage = page
            self?.userModels.append(contentsOf: models)
            
            self?.tableView.reloadData()
            self?.isLoading = false
            
            self?.showNoData()
        })
    }
    
    /// nodata表示
    private func showNoData() {
        self.nodataImageView.isHidden = self.userModels.count == 0 ? false : true
    }
}

//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    /// 編集が開始されたら、キャンセルボタンを有効にする
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }

    /// キャンセルボタンが押されたらキャンセルボタンを無効にしてフォーカスを外す
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    /// 検索ボタンタップ時
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.displayPage = 1
        self.userModels.removeAll()
        self.request()
        
        searchBar.resignFirstResponder()
    }
}

//MARK: - UIScrollViewDelegate
extension SearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPosition = self.tableView.contentOffset.y + self.tableView.frame.size.height
        let threshold = self.tableView.contentSize.height - self.tableView.contentSize.height * 0.2
        
        if (currentPosition > threshold &&
            self.tableView.isDragging && !self.isLoading) {
            
            self.isLoading = true
            
            self.requestSearch(page: self.displayPage + 1)
        }
    }
}

//MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewCell.identifier,
                                                    for: indexPath) as? SearchViewCell {
            
            let model = self.userModels[indexPath.row]
            cell.setup(model: model)
            return cell
        }
        
        return UITableViewCell()
    }
}

//MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    /// セルタップ時
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        self.tableView?.deselectRow(at: indexPath, animated: false)
        
        let model = self.userModels[indexPath.row]
        self.performSegue(withIdentifier: UserDetailViewController.identifier,
                          sender: model)
    }
}

//MARK: - Notification
extension SearchViewController {
    /// キーボード表示
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any] else {
            return
        }
        guard let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else {
            return
        }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        UIView.animate(withDuration: duration, animations: {
            self.tableView.contentInset = contentInsets
            self.tableView.scrollIndicatorInsets = contentInsets
            self.view.layoutIfNeeded()
        })
    }
    
    /// キーボード非表示
    @objc private func keyboardWillHide(_ notification: Notification) {
        self.tableView.contentInset = .zero
        self.tableView.scrollIndicatorInsets = .zero
    }
}
