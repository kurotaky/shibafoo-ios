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
    
    @IBAction func loginButtonDidPush(_ sender: UIButton) {
        let email = emailTextField.text
        let password = passwordTextField.text
        let loginUrl = EndpointConst().URL + "users/sign_in.json"
        let params = ["user": ["email": email!, "password": password!] as AnyObject]
        Alamofire.request(loginUrl, method: .post, parameters: params)
            .responseJSON { response in
                print(response.response?.statusCode)
                if response.response?.statusCode == 201 {
                    if let json: AnyObject = response.result.value as AnyObject? {
                      let token = json["authentication_token"]
                      let userDefaults = UserDefaults.standard
                      userDefaults.set(token!, forKey: "authentication_token")
                      userDefaults.set(email, forKey: "email")
                      userDefaults.synchronize()
                      let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabNavigationController") as? UINavigationController
                      self.navigationController?.present(navigationController!, animated: true, completion: nil)
                    }
                } else {
                    // アラート、APIのerror messageを表示
                    print(response.result.value)
                    if let json: AnyObject = response.result.value as AnyObject? {
                      let errorMessage = json["error"] as? String
                      let alertController = UIAlertController(title: "エラー", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
                      alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                      self.navigationController?.present(alertController, animated: true, completion: nil)
                    }
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
