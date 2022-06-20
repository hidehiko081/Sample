//
//  UserDetailRepositoryViewCell.swift
//  GitHub
//
//  Created by aihara hidehiko on 2022/04/29.
//

import Foundation
import UIKit
import QuartzCore


class UserDetailRepositoryViewCell:  UITableViewCell {
    /// ユーザー情報
    var model: UserRepositoryModel?
    
    /// タイトル
    @IBOutlet weak var titleLabel: UILabel!
    /// 説明
    @IBOutlet weak var descriptionLabel: UILabel!
    /// スター
    @IBOutlet weak var stargazersCountLabel: UILabel!
    /// 言語
    @IBOutlet weak var languageLabel: UILabel!
    /// fork
    @IBOutlet weak var forkLabel: UILabel!
}

//MARK: - Private
extension UserDetailRepositoryViewCell {
    func show() {
        guard let model = self.model else {
            return
        }
        self.titleLabel.text = model.name
        if model.name == nil {
            print(model)
        }
        let description = model.description ?? ""
        self.descriptionLabel.text = description.count > 0 ? (" - " + description) : nil
        
        self.stargazersCountLabel.text = Utility.getComma(num: model.stargazersCount ?? 0)
        self.languageLabel.text = model.language ?? "-"
        
        self.forkLabel.text = Utility.getComma(num: model.forks ?? 0)
    }
}

//MARK: - Public
extension UserDetailRepositoryViewCell {
    /// セットアップ
    func setup(model: UserRepositoryModel) {
        self.model = model
        
        self.show()
    }
}
