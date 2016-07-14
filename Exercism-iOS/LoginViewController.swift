//
//  LoginViewController.swift
//  Exercism-iOS
//
//  Created by Hom, Kenneth on 3/24/16.
//  Copyright © 2016 Hom, Kenneth. All rights reserved.
//

import UIKit
import OAuthSwift

class LoginViewController: OAuthWebViewController {
    
    var targetURL : NSURL = NSURL()
    let webView : UIWebView = UIWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.frame = UIScreen.mainScreen().bounds
        self.webView.scalesPageToFit = true
        self.webView.delegate = self
        self.view.addSubview(self.webView)
        loadAddressURL()
    }

    override func handle(url: NSURL) {
        targetURL = url
        super.handle(url)
        
        loadAddressURL()
    }
    
    func loadAddressURL() {
        let req = NSURLRequest(URL: targetURL)
        self.webView.loadRequest(req)
    }
}
    
// MARK: delegate
extension LoginViewController: UIWebViewDelegate {
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let url = request.URL where (url.scheme == "oauth-swift"){
            self.dismissWebViewController()
        }
        return true
    }
}



