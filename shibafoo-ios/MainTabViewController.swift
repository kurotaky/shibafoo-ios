//
//  MainTabViewController.swift
//  shibafoo-ios
//
//  Created by usr0600244 on 2015/09/01.
//  Copyright (c) 2015年 mo-fu. All rights reserved.
//

import UIKit
import Alamofire

class MainTabViewController: UITabBarController, UITabBarControllerDelegate {
    
    @IBOutlet weak var logSegmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.items?[0].image = UIImage(named: "footer_icon_home_off")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.delegate = self
    }
    
    fileprivate var isAuthenticated = false
    
    override func viewWillAppear(_ animated: Bool) {
        // トークンがセットされていたらAPIにtokenとemailを送って認証する
        let userDefault = UserDefaults.standard
        if let token = userDefault.object(forKey: "authentication_token") as? String {
            if let email = userDefault.object(forKey: "email") as? String {
                authenticationFromToken(token, email: email)
            }
        } else {
            // tokenがない場合はログイン画面を表示
            let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "LoginNavigationController") as? UINavigationController
            self.navigationController?.present(navigationController!, animated: true, completion: nil)
        }
    }
    
    func authenticationFromToken(_ token: String, email: String) {
        let params = ["authentication_token": token, "email": email]
        Alamofire.request(EndpointConst().URL + "api/posts.json", parameters: params)
            .responseJSON { response in
                if response.result.value != nil {
                    self.isAuthenticated = true
                } else {
                    self.isAuthenticated = false
                }
                
                if !self.isAuthenticated {
                    // 認証していない場合はログイン画面を表示
                    let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "LoginNavigationController") as? UINavigationController
                    self.navigationController?.present(navigationController!, animated: true, completion: nil)
                }
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if self.selectedIndex != 0 {
            self.logSegmentedControl.isHidden = true
        } else {
            self.logSegmentedControl.isHidden = false
        }
    }

    @IBAction func unwindToMainTabViewController(_ segue: UIStoryboardSegue) {
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
