//
//  WebViewController.swift
//  GitHub
//
//  Created by aihara hidehiko on 2022/04/29.
//

import Foundation
import UIKit
import WebKit

class WebViewController: UIViewController {
    var webTitle: String?
    var requestUrl: String?
    
    /// web
    @IBOutlet weak var webView: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

//MARK: - Private
extension WebViewController {
    /// セットアップ
    private func setup() {
        self.setupNavigation()
        self.setupWebView()
    }
    
    /// ナビゲーションバーセットアップ
    private func setupNavigation() {
        self.navigationItem.title = self.webTitle
        
        let sendButton = UIBarButtonItem.setupBarButton(image: UIImage(systemName: "square.and.arrow.up"),
                                                        delegate: self,
                                                        action: #selector(self.touchUpInsideSendButton(_:)))
        self.navigationItem.rightBarButtonItem = sendButton
    }
    
    /// webviewセットアップ
    private func setupWebView() {
        guard let htmlUrl = self.requestUrl else {
            return
        }
        
        if htmlUrl.count < 0 {
            return
        }
        
        guard let myURL = URL(string: htmlUrl) else {
            return
        }
        let myRequest = URLRequest(url: myURL)
        //デリケート設定
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        
        //フリップでの戻る・進むを有効にする
        self.webView.allowsBackForwardNavigationGestures = true
        
        //ページ読み込み
        self.webView?.load(myRequest)
    }
    
    /// シェアー
    private func shareActivity() {
        let title = self.webTitle ?? ""
        guard let htmlUrl = self.requestUrl else {
            return
        }
        
        let items = [title, htmlUrl] as [Any]
        let activityVc = UIActivityViewController(activityItems: items,
                                                  applicationActivities: nil)
        self.present(activityVc, animated: true, completion: nil)
    }
}

//MARK: - WKUIDelegate, WKNavigationDelegate
extension WebViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        
        if url.absoluteString.range(of: "//itunes.apple.com/") != nil {
            if UIApplication.shared.responds(to: #selector(UIApplication.open(_:options:completionHandler:))) {
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([convertFromUIApplicationOpenExternalURLOptionsKey(UIApplication.OpenExternalURLOptionsKey.universalLinksOnly):false]), completionHandler: { (finished: Bool) in
                })
            }
            else {
                // iOS 10 で deprecated 必要なら以降のopenURLも振り分ける
                // iOS 10以降は UIApplication.shared.open(url, options: [:], completionHandler: nil)
                self.openUrl(url: url)
            }
            decisionHandler(.cancel)
            return
        }
        else if !url.absoluteString.hasPrefix("http://")
            && !url.absoluteString.hasPrefix("https://") {
            // URL Schemeをinfo.plistで公開しているアプリか確認
            if UIApplication.shared.canOpenURL(url) {
                self.openUrl(url: url)
                decisionHandler(.cancel)
                return
            }
        }
        
        switch navigationAction.navigationType {
        case .linkActivated:
            if navigationAction.targetFrame == nil
                || !navigationAction.targetFrame!.isMainFrame {
                // <a href="..." target="_blank"> が押されたとき
                webView.load(URLRequest(url: url))
                decisionHandler(.cancel)
                return
            }
        case .backForward:
            break
        case .formResubmitted:
            break
        case .formSubmitted:
            break
        case .other:
            break
        case .reload:
            break
        @unknown default:
            break
        } // 全要素列挙した場合はdefault不要 (足りない要素が追加されたときにエラーを吐かせる目的)
        
        decisionHandler(.allow)
    }
    
    func openUrl(url: URL) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIApplicationOpenExternalURLOptionsKey(_ input: UIApplication.OpenExternalURLOptionsKey) -> String {
    return input.rawValue
}


//MARK: - Action
extension WebViewController {
    /// web戻るボタンタップ時
    @IBAction func touchUpInsideWebBackButton(_ sender: Any) {
        guard let web = self.webView else {
            return
        }
        
        if web.canGoBack  {
            // web上で戻る
            web.goBack()
        }
    }
    
    /// web進むボタンタップ時
    @IBAction func touchUpInsideWebForwardButton(_ sender: Any) {
        guard let web = self.webView else {
            return
        }
        
        if web.canGoForward  {
            // web上で進む
            web.goForward()
        }
    }
    
    /// 送信ボタンタップ時
    @objc func touchUpInsideSendButton(_ sender: AnyObject) {
        self.shareActivity()
    }
}
