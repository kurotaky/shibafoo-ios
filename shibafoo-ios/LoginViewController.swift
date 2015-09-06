//
//  LoginViewController.swift
//  shibafoo-ios
//
//  Created by usr0600244 on 2015/08/28.
//  Copyright (c) 2015年 mo-fu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

// ログイン画面
class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonDidPush(sender: UIButton) {
        let email = emailTextField.text
        let password = passwordTextField.text
        let loginUrl = "http://www.shibafoo.com/users/sign_in.json"
        let params = ["user": ["email": email, "password": password]]
        Alamofire.request(.POST, loginUrl, parameters: params)
            .response { request, response, data, error in
                if response?.statusCode == 201 {
                    let json = JSON(data: data!)
                    let token: String? = json["authentication_token"].string
                    let userDefaults = NSUserDefaults.standardUserDefaults()
                    userDefaults.setObject(token!, forKey: "authentication_token")
                    userDefaults.setObject(email, forKey: "email")
                    userDefaults.synchronize()
                    let navigationController = self.storyboard?.instantiateViewControllerWithIdentifier("MainTabNavigationController") as? UINavigationController
                    self.navigationController?.presentViewController(navigationController!, animated: true, completion: nil)
                } else {
                    // アラート、APIのerror messageを表示
                    let json = JSON(data: data!)
                    let errorMessage: String? = json["error"].string
                    let alertController = UIAlertController(title: "エラー", message: errorMessage!, preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                    self.navigationController?.presentViewController(alertController, animated: true, completion: nil)
                }
        }
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
