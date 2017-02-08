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
    var parsedPost: ParsedPost? = nil
    var parsedReplyPost: ParsedReplyPost? = nil

    @IBOutlet weak var postTextField: UITextView!

    @IBAction func postDidPush(_ sender: UIButton) {
        let content = postTextField.text
        let postUrl = EndpointConst().URL + "api/posts"
        let userDefault = UserDefaults.standard
        let token = userDefault.object(forKey: "authentication_token") as? String
        let email = userDefault.object(forKey: "email") as? String
        var params = ["content": content!, "email": email!, "token": token!] as [String: Any]
        if self.parsedPost != nil {
            params["post_id"] = self.parsedPost?.id
        }
        if self.parsedReplyPost != nil {
            params["post_id"] = self.parsedReplyPost?.id
        }
        Alamofire.request(postUrl, method: .post, parameters: params)
            .responseJSON { response in
                if (response.response?.statusCode == 200) {
                    print("Success!")
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("Error: \(response.data)")
                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.parsedPost != nil {
            let fooButton = self.view.viewWithTag(1) as? UIButton
            fooButton?.setTitle("ReFoo!", for: UIControlState.normal)
        } else if self.parsedReplyPost != nil {
            let fooButton = self.view.viewWithTag(1) as? UIButton
            fooButton?.setTitle("ReFoo!", for: UIControlState.normal)
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
