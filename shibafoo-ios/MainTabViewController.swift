//
//  MainTabViewController.swift
//  shibafoo-ios
//
//  Created by usr0600244 on 2015/09/01.
//  Copyright (c) 2015年 mo-fu. All rights reserved.
//

import UIKit
import Alamofire

class MainTabViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private var isAuthenticated = false
    
    override func viewWillAppear(animated: Bool) {
        // トークンがセットされていたらAPIにtokenとemailを送って認証する
        let userDefault = NSUserDefaults.standardUserDefaults()
        if let token = userDefault.objectForKey("authentication_token") as? String {
            if let email = userDefault.objectForKey("email") as? String {
                authenticationFromToken(token, email: email)
            }
        } else {
            // tokenがない場合はログイン画面を表示
            let navigationController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginNavigationController") as? UINavigationController
            self.navigationController?.presentViewController(navigationController!, animated: true, completion: nil)
        }
    }
    
    func authenticationFromToken(token: String, email: String) {
        let params = ["authentication_token": token, "email": email]
        Alamofire.request(.GET, "http://www.shibafoo.com/api/posts.json", parameters: params)
        // Alamofire.request(.GET, "http://localhost:3000/api/posts", parameters: params)
            .response { request, response, data, error in
                if response?.statusCode == 200 {
                    self.isAuthenticated = true
                } else {
                    self.isAuthenticated = false
                }
                if !self.isAuthenticated {
                    // 認証していない場合はログイン画面を表示
                    let navigationController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginNavigationController") as? UINavigationController
                    self.navigationController?.presentViewController(navigationController!, animated: true, completion: nil)
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
