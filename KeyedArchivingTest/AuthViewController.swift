//
//  AuthViewController.swift
//  KeyedArchivingTest
//
//  Created by 北䑓 如法 on 18/4/13.
//  Copyright © 2018年 北䑓 如法. All rights reserved.
//

import Cocoa
import WebKit
import OAuthSwift

class AuthViewController: NSViewController, OAuthSwiftURLHandlerType, WKNavigationDelegate, WKUIDelegate  {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func handle(_ url: URL) {
        webView.load(URLRequest(url: url))
    }
    
    public func webView(_ sender: WKWebView, didFinish navigation: WKNavigation!) {
        if let url = sender.url {
            print("did finish: \(url)")
            let u = url.absoluteString
            if u.hasPrefix("https://nyoho.jp/oauth/") {
                print("Arrived callback page")
                OAuthSwift.handle(url: url)
                self.dismiss(self)
            }
        }
    }

    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
    
    public func clearCookiesAndSessions() {
        let dataTypes = Set([WKWebsiteDataTypeCookies,
                             WKWebsiteDataTypeLocalStorage, WKWebsiteDataTypeSessionStorage,
                             WKWebsiteDataTypeWebSQLDatabases, WKWebsiteDataTypeIndexedDBDatabases])
        WKWebsiteDataStore.default().removeData(ofTypes: dataTypes, modifiedSince: Date.distantPast, completionHandler: {})
    }
}
