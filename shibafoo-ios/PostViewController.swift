//
//  PostViewController.swift
//  shibafoo-ios
//
//  Created by usr0600244 on 2015/09/06.
//  Copyright (c) 2015年 mo-fu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PostViewController: UIViewController {

    @IBOutlet weak var postTextField: UITextView!
    @IBAction func postDidPush(_ sender: UIButton) {
        let content = postTextField.text
        let postUrl = "https://shibafoo-shibafoo.sqale.jp/api/posts"
        let userDefault = UserDefaults.standard
        let token = userDefault.object(forKey: "authentication_token") as? String
        let email = userDefault.object(forKey: "email") as? String
        let params = ["content": content!, "email": email!, "token": token!]
        Alamofire.request(postUrl, method: .post, parameters: params)
            .responseJSON { response in
                if (response.result.value != nil) {
                    // unwind segue
                    print("Success!")
                } else {
                    print("Error: \(response.data)")
                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
