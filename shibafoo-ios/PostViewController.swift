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
    @IBAction func postDidPush(sender: UIButton) {
        let content = postTextField.text
        let postUrl = "http://www.shibafoo.com/api/posts"
        let userDefault = NSUserDefaults.standardUserDefaults()
        let token = userDefault.objectForKey("authentication_token") as? String
        let email = userDefault.objectForKey("email") as? String
        let params = ["content": content!, "email": email!, "token": token!]
        Alamofire.request(.POST, postUrl, parameters: params)
            .response { request, response, data, error in
                if response?.statusCode == 200 {
                    // unwind segue
                    print("Success!")
                } else {
                    print("Error: \(response) \(data)")
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
