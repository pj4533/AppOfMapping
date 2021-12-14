//
//  WebViewController.swift
//  Slaad
//
//  Created by PJ Gray on 5/1/19.
//  Copyright © 2019 Say Goodnight. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

protocol WebViewDelegate {
    func loggedInWebView()
}

class WebViewController: UIViewController, WKNavigationDelegate {
    var delegate : WebViewDelegate?
    var loggingIn : Bool = false
    
    @IBOutlet weak var webview: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webview.navigationDelegate = self
        if let url = URL(string: "https://www.dndbeyond.com/login") {
            let request = URLRequest(url: url)
            self.webview.load(request)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            if url.absoluteString.contains("www.dndbeyond.com/login-callback?code=") {
                self.loggingIn = true
                SVProgressHUD.show()
            }
        }
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if self.loggingIn {
            SVProgressHUD.dismiss()
            self.dismiss(animated: true, completion: nil)
            self.delegate?.loggedInWebView()
        }
    }
}
