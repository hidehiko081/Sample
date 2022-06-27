//
//  UserDetailViewController.swift
//  GitHub
//
//  Created by aihara hidehiko on 2022/04/29.
//

import Foundation
import UIKit
import AlamofireImage
import SVProgressHUD

class UserDetailViewController: UIViewController {
    /// プロトコル
    let networkProtocol = NetworkProtocolImpl()
    /// ユースケース
    let userUseCase = UserUseCaseImpl()
    /// ユーザー
    var model: UserModel?
    /// 詳細
    var detailModel: UserDetailModel?
    /// リポジトリ
    var repositoryModels = [UserRepositoryModel]()
    /// 読み込み完了
    var isLoading = false
    /// ページ数
    var displayPage = 1
    
    /// no data
    @IBOutlet weak var nodataImageView: UIImageView!
    /// ユーザー
    @IBOutlet weak var userView: UIView!
    /// アイコン
    @IBOutlet weak var iconImageView: UIImageView!
    /// ユーザー名
    @IBOutlet weak var userNameLabel: UILabel!
    /// フルネーム
    @IBOutlet weak var fullNameLabel: UILabel!
    /// フォロワー数
    @IBOutlet weak var followersStackView: UIStackView!
    @IBOutlet weak var followersLabel: UILabel!
    /// フォロイー数
    @IBOutlet weak var followingStackView: UIStackView!
    @IBOutlet weak var followingLabel: UILabel!
    
    /// テーブル
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
}

//MARK: - Segue
extension UserDetailViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? WebViewController {
            if let model = sender as? UserRepositoryModel {
                viewController.requestUrl = model.htmlUrl
                viewController.webTitle = model.name
            } else if let model = sender as? UserDetailModel {
                viewController.requestUrl = self.model?.htmlUrl
                viewController.webTitle = model.name ?? self.model?.login
            }
        }
        else if let viewController = segue.destination as? FollowViewController {
            if let type = sender as? FollowType {
                viewController.type = type
            }
            viewController.userModel = self.model
        }
        
        
    }
}

//MARK: - Private
extension UserDetailViewController {
    /// セットアップ
    private func setup() {
        self.setupNavigation()
        self.setupTableView()
        self.setupTapGesture()
        self.request()
    }
    
    /// ナビゲーションセットアップ
    private func setupNavigation() {
        self.navigationItem.title = self.model?.login
        self.updateFavoriteButton()
    }
    
    /// テーブルセットアップ
    private func setupTableView() {
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.layoutMargins = UIEdgeInsets.zero
        
        let identifiers = [UserDetailRepositoryViewCell.identifier,
        ]
        
        for identifier in identifiers {
            self.tableView.register(
                UINib(nibName: identifier, bundle: Bundle.main),
                forCellReuseIdentifier: identifier)
        }
    }
    
    /// タップセットアップ
    private func setupTapGesture() {
        let tapUser = UITapGestureRecognizer(target: self,
                                             action: #selector(self.tapUser(_:)))
        self.userView.addGestureRecognizer(tapUser)
        
        let tapFollowers = UITapGestureRecognizer(target: self,
                                                  action: #selector(self.tapFollowers(_:)))
        self.followersStackView.addGestureRecognizer(tapFollowers)
        
        let tapFollowing = UITapGestureRecognizer(target: self,
                                                  action: #selector(self.tapFollowing(_:)))
        self.followingStackView.addGestureRecognizer(tapFollowing)
    }
    
    /// リクエスト
    private func request() {
        self.requestDetail()
        self.requestRepository(page: self.displayPage)
    }
    
    /// 詳細リクエスト
    private func requestDetail() {
        guard let login = self.model?.login else {
            return
        }
        
        guard let url = NetworkAPI.getUserDetail(login: login).getUrl()?.absoluteString else {
            return
        }
        
        SVProgressHUD.show()
        
        self.networkProtocol.requestUserDetail(url: url,
                                               parameters: nil,
                                               completionHandler: {[weak self] model in
            
            self?.detailModel = model
            self?.showUserDetail()
            
            SVProgressHUD.dismiss(withDelay: 0.3)
        })
    }
    
    /// 詳細表示
    private func showUserDetail() {
        if let avatarUrl = self.model?.avatarUrl, let url = URL(string: avatarUrl) {
            self.iconImageView.af.setImage(withURL: url)
            self.iconImageView.layer.masksToBounds = false
            self.iconImageView.layer.cornerRadius = self.iconImageView.frame.width / 2
            self.iconImageView.clipsToBounds = true
        }
        self.userNameLabel.text = self.model?.login
        self.fullNameLabel.text = self.detailModel?.name
        let followers = self.detailModel?.followers ?? 0
        self.followersLabel.text = Utility.getComma(num: followers)
        
        let following = self.detailModel?.following ?? 0
        self.followingLabel.text = Utility.getComma(num: following)
    }
    
    /// リポジトリリクエスト
    private func requestRepository(page: Int) {
        guard let login = self.model?.login else {
            return
        }
        
        guard let url = NetworkAPI.getUserRepos(login: login, pageIndex: page).getUrl()?.absoluteString else {
            return
        }
        
        self.networkProtocol.requestUserRepository(url: url,
                                                   parameters: nil,
                                                   completionHandler: {[weak self] models in
            guard let models = models else {
                self?.showNoData()
                self?.isLoading = false
                return
            }
            
            let addModels = models.filter{$0.isFork == false}
            if addModels.count == 0 {
                self?.showNoData()
                self?.isLoading = false
                return
            }
            
            self?.displayPage = page
            self?.repositoryModels.append(contentsOf: addModels)
            
            self?.tableView.reloadData()
            self?.isLoading = false
            
            self?.showNoData()
        })
    }
    
    /// nodata表示
    private func showNoData() {
        self.nodataImageView.isHidden = self.repositoryModels.count == 0 ? false : true
    }
    
    /// お気に入りボタン更新
    private func updateFavoriteButton() {
        let name = self.getFavorite() ? "pin.circle.fill" : "pin.circle"
        let button = UIBarButtonItem.setupBarButton(image: UIImage(systemName: name),
                                                    delegate: self,
                                                    action: #selector(touchUpInsideFavoriteButton(_:)))
        self.navigationItem.rightBarButtonItem = button
    }
    
    /// お気に入り判定
    private func getFavorite() -> Bool {
        guard let id = self.model?.id else {
            return false
        }
        
        let model = self.userUseCase.getFavorite(userId: id)
        return model != nil ? true : false
    }
}

//MARK: - UIScrollViewDelegate
extension UserDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPosition = self.tableView.contentOffset.y + self.tableView.frame.size.height
        let threshold = self.tableView.contentSize.height - self.tableView.contentSize.height * 0.2
        
        if (currentPosition > threshold &&
            self.tableView.isDragging && !self.isLoading) {
            
            self.isLoading = true
            
            self.requestRepository(page: self.displayPage + 1)
        }
    }
}

//MARK: - UITableViewDataSource
extension UserDetailViewController: UITableViewDataSource {
    /// セクション数を返す
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// セクション内のセル数を返す
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.repositoryModels.count
    }
    
    /// セクションのヘッダーの高さ
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        let publicRepos = self.detailModel?.publicRepos ?? 0
        return (publicRepos > 0) ? 25 : 0
    }

    /// セクションのヘッダー
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let label : UILabel = UILabel()
        label.backgroundColor = .systemBlue
        label.textColor = UIColor.white
        label.text = " repos "//" repos: " + String(self.detailModel?.publicRepos ?? 0)
        
        label.layer.cornerRadius = 10
        label.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        label.clipsToBounds = true

        return label
    }
    
    /// セルの高さ
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    /// セルを返す
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: UserDetailRepositoryViewCell.identifier,
                                                    for: indexPath) as? UserDetailRepositoryViewCell {
            let model = self.repositoryModels[indexPath.row]
            cell.setup(model: model)
            return cell
        }
        
        return UITableViewCell()
    }
}

//MARK: - UITableViewDelegate
extension UserDetailViewController: UITableViewDelegate {
    /// セルタップ時
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        self.tableView?.deselectRow(at: indexPath, animated: false)
        
        let model = self.repositoryModels[indexPath.row]
        self.performSegue(withIdentifier: WebViewController.identifier,
                          sender: model)
    }
}


//MARK: - Action
extension UserDetailViewController {
    /// お気に入りボタンタップ時
    @objc func touchUpInsideFavoriteButton(_ sender: AnyObject) {
        guard let model = self.model else {
            return
        }
        guard let userId = model.id else {
            return
        }
        if self.getFavorite() {
            self.userUseCase.deleteFavorite(userId: userId) { result in
                if result {
                    self.updateFavoriteButton()
                }
            }
        } else {
            self.userUseCase.saveFavorite(model: UserFavoriteModel(id: nil,
                                                                   login: model.login,
                                                                   userId: userId,
                                                                   avatarUrl: model.avatarUrl,
                                                                   name: nil)) { result, model in
                if result {
                    self.updateFavoriteButton()
                }
            }
        }
    }
    
    /// ユーザー情報タップ時
    @objc func tapUser(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: WebViewController.identifier,
                          sender: self.detailModel)
    }
    
    
    /// フォロワータップ時
    @objc func tapFollowers(_ sender: UITapGestureRecognizer) {
        let followers = self.detailModel?.followers ?? 0
        if followers == 0 {
            return
        }
        
        self.performSegue(withIdentifier: FollowViewController.identifier,
                          sender: FollowType.followers)
    }
    
    /// フォロー中タップ時
    @objc func tapFollowing(_ sender: UITapGestureRecognizer) {
        let following = self.detailModel?.following ?? 0
        if following == 0 {
            return
        }
        
        self.performSegue(withIdentifier: FollowViewController.identifier,
                          sender: FollowType.following)
    }
    
}
