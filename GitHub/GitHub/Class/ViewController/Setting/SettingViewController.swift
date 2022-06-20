//
//  SettingViewController.swift
//  GitHub
//
//  Created by aihara hidehiko on 2022/04/29.
//

import Foundation
import UIKit
import MessageUI


class SettingViewController: UIViewController {
    /// テーブル
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
}

//MARK: - Private
extension SettingViewController {
    
    /// セットアップ
    func setup() {
        self.setupNavigationBar()
        self.setupTableView()
    }
    
    /// ナビゲーションバー
    func setupNavigationBar() {
        self.navigationItem.title = "Setting"
    }
    
    /// テーブル初期設定
    func setupTableView() {
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.layoutMargins = UIEdgeInsets.zero
        
        let identifiers = [MailViewCell.identifier,
                           ShareViewCell.identifier,
                           EvaluationViewCell.identifier,
        ]
        
        for identifier in identifiers {
            self.tableView.register(
                UINib(nibName: identifier, bundle: Bundle.main),
                forCellReuseIdentifier: identifier)
        }
    }
    
    /// メール送信
    func sendMail() {
        if MFMailComposeViewController.canSendMail()==false {
            print("Email Send Failed")
            return
        }
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        
        let mailViewController = MFMailComposeViewController()
        
        mailViewController.mailComposeDelegate = self
        mailViewController.setSubject("問い合わせ")
        mailViewController.setToRecipients(["hidehiko.aihara@gmail.com"])
        mailViewController.setMessageBody("version: " + version + "\n下記に問い合わせ内容をお願い致します。\n\n", isHTML: false)
        
        self.present(mailViewController, animated: true, completion: nil)
    }
    
    /// url開く
    func openUrl(urlStr: String) {
        guard let url = URL(string: urlStr) else {
            return
        }
        UIApplication.shared.open(url,
                                  options: [:],
                                  completionHandler: nil)
    }
    
    /// 共有
    func share() {
        let urlStr = "https://apps.apple.com/app/id" + Const.appleID
        guard let url = URL(string: urlStr) else {
            return
        }
        
        let items = [ url ]
        let activityViewController = UIActivityViewController(activityItems: items,
                                                              applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.excludedActivityTypes = [.postToTwitter,
                                                        .postToFacebook]
        
        self.present(activityViewController,
                     animated: true,
                     completion: nil)
    }
}

//MARK: - UITableViewDelegate
extension SettingViewController: UITableViewDelegate {
    /// セクション数を返す
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// セクション内のセル数を返す
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 3
        default:
            return 0
        }
    }
    
    /// セルの高さ
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
    /// セルを返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                if let cell = tableView.dequeueReusableCell(withIdentifier: MailViewCell.identifier,
                                                            for: indexPath) as? MailViewCell {
                    return cell
                }
                break
                
            case 1:
                if let cell = tableView.dequeueReusableCell(withIdentifier: ShareViewCell.identifier,
                                                            for: indexPath) as? ShareViewCell {
                    return cell
                }
                break
                
            case 2:
                if let cell = tableView.dequeueReusableCell(withIdentifier: EvaluationViewCell.identifier,
                                                            for: indexPath) as? EvaluationViewCell {
                    return cell
                }
                break
                
            default:
                break
            }
            
        default:
            break
        }
        
        return UITableViewCell()
    }
}

//MARK: - UITableViewDataSource
extension SettingViewController: UITableViewDataSource {
    /// セルタップ時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView?.deselectRow(at: indexPath, animated: false)
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                // 問い合わせ
                self.sendMail()
                break
                
            case 1:
                // アプリ共有
                self.share()
                break
                
            case 2:
                // アプリの評価
                self.openUrl(urlStr: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=" + Const.appleID)
                break
                
            default:
                break
            }
            break

        default:
            break
        }
    }
}

//MARK: - MFMailComposeViewControllerDelegate
extension SettingViewController: MFMailComposeViewControllerDelegate {
    /// メール送信結果
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        switch result {
        case .cancelled:
            // メールキャンセル
            print("メールキャンセル")
            break
            
        case .saved:
            // 下書き保存
            print("下書き保存")
            break
            
        case .sent:
            // メール送信
            print("メール送信")
            break
            
        case .failed:
            // メール送信失敗
            print("メール送信失敗")
            break
        default:
            break
        }
        
        // 画面閉じる
        self.dismiss(animated: true, completion: nil)
    }
}

