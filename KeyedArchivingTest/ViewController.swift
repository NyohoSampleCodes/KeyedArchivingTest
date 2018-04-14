//
//  ViewController.swift
//  KeyedArchivingTest
//
//  Created by 北䑓 如法 on 18/4/13.
//  Copyright © 2018年 北䑓 如法. All rights reserved.
//

import Cocoa
import OAuthSwift

class ViewController: NSViewController {
    var oauthswift = OAuth1Swift(consumerKey:     "You can get it from http://www.hatena.ne.jp/oauth/develop",
                                 consumerSecret:  "You can get it from http://www.hatena.ne.jp/oauth/develop",
                                 requestTokenUrl: "https://www.hatena.com/oauth/initiate?scope=read_public,write_public",
                                 authorizeUrl:    "https://www.hatena.ne.jp/oauth/authorize",
                                 accessTokenUrl:  "https://www.hatena.com/oauth/token")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func checkAuthed(_ sender: Any) {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: "/tmp/delete-it-later.plist"))
            if let c = NSKeyedUnarchiver.unarchiveObject(with: data) as? OAuthSwiftCredential {
                print(c.oauthToken)
                print(c.oauthTokenSecret)
                print(c.oauthVerifier)
                print(c.version)
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    public func auth(viewController: AuthViewController) {
        oauthswift.authorizeURLHandler = viewController
        oauthswift.authorize(
            withCallbackURL: URL(string: "https://nyoho.jp/oauth/")!,
            success: { credential, response, parameters in
                print("Authentification succeeded.")
                let d = NSKeyedArchiver.archivedData(withRootObject: credential)
                do {
                    try d.write(to: URL(fileURLWithPath: "/tmp/delete-it-later.plist"))
                } catch {
                }
        },
            failure: { error in
                print("Authentification failed.")
                print(error.localizedDescription)
        })
    }

    @IBAction func action(_ sender: Any) {
        let vc = AuthViewController.init(nibName: nil, bundle: Bundle.main)
        self.presentViewControllerAsModalWindow(vc)
        auth(viewController: vc)
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        switch (segue.identifier?.rawValue, segue.destinationController) {
        case ("AuthView"?, let viewController as AuthViewController):
            auth(viewController: viewController)
        default:
            break
        }
    }
    
    override var representedObject: Any? {
        didSet {
        }
    }
}

