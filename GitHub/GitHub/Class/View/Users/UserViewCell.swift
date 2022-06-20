//
//  UserViewCell.swift
//  GitHub
//
//  Created by aihara hidehiko on 2022/04/29.
//

import Foundation
import UIKit
import QuartzCore
import AlamofireImage


class UserViewCell:  UITableViewCell {
    /// ユーザー情報
    var model: UserModel?
    
    /// ユーザー名
    @IBOutlet weak var nameLabel: UILabel!
    /// アイコン
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.iconImageView.layer.masksToBounds = false
        self.iconImageView.layer.cornerRadius = self.iconImageView.frame.width / 2
        self.iconImageView.clipsToBounds = true
    }
}

//MARK: - Private
extension UserViewCell {
    func show() {
        guard let model = self.model else {
            return
        }
        self.nameLabel.text = model.login
        if let avatarUrl = model.avatarUrl, let url = URL(string: avatarUrl) {
            self.iconImageView.af.setImage(withURL: url)
        } else {
            self.iconImageView.image = UIImage(systemName: "person.crop.circle")
        }
    }
    
}

//MARK: - Public
extension UserViewCell {
    /// セットアップ
    func setup(model: UserModel) {
        self.model = model
        
        self.show()
    }
}
