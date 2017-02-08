//
//  SettingTableViewController.swift
//  shibafoo-ios
//
//  Created by usr0600244 on 2016/11/24.
//  Copyright © 2016年 mo-fu. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "ログアウト", message: "ログアウトしますか？", preferredStyle: UIAlertControllerStyle.alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            let userDefaults = UserDefaults.standard
            userDefaults.removeObject(forKey: "email")
            userDefaults.removeObject(forKey: "authentication_token")
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "MainTabNavigationController")
            appDelegate.window?.rootViewController = viewController
            appDelegate.window?.makeKeyAndVisible()
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
        })
        
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
}
