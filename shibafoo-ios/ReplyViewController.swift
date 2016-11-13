//
//  ReplyViewController.swift
//  shibafoo-ios
//
//  Created by usr0600244 on 2015/09/01.
//  Copyright (c) 2015年 mo-fu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ReplyViewController: UITableViewController {

    var parsedReplyPosts : Array <ParsedReplyPost> = []
    
    @IBAction func handleRefresh(_ sender: AnyObject?) {
        self.parsedReplyPosts.append(ParsedReplyPost(content: "New row", createdAt: Date().description, avatarURL: defaultAvatarURL, nickname: "new", title: "title"))
        reloadPosts()
        refreshControl!.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "ReFoo!"
        reloadPosts()
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(ReplyViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        self.refreshControl = refresher
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedReplyPosts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomReplyPostCell") as? ParsedReplyPostCell
        let parsedReplyPost = parsedReplyPosts[(indexPath as NSIndexPath).row]
        cell?.contentLabel.text = parsedReplyPost.content
        cell?.createdAtLabel.text = parsedReplyPost.createdAt
        cell?.nicknameLabel.text = parsedReplyPost.nickname
        cell?.titleLabel.text = parsedReplyPost.title
        if parsedReplyPost.avatarURL != nil {
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {() -> Void in
                    let avatarImage = UIImage(data: try! Data (
                        contentsOf: parsedReplyPost.avatarURL! as URL))
                    DispatchQueue.main.async(execute: {
                            cell?.avatarImageView.image = avatarImage
                    })
                }
            )
            cell?.avatarImageView.image = UIImage (data: try! Data(contentsOf: parsedReplyPost.avatarURL! as URL))
       }
        return cell!
    }

    func reloadPosts() {
        let userDefault = UserDefaults.standard
        let token = userDefault.object(forKey: "authentication_token") as? String
        let email = userDefault.object(forKey: "email") as? String
        Alamofire.request(EndpointConst().URL + "api/posts/reply", parameters: ["email": email!, "token": token!])
            .responseJSON { data in
              self.parsedReplyPosts.removeAll(keepingCapacity: true)
                if let jsonData: DataResponse<Any> = data as DataResponse? {
                let posts = JSON(jsonData.data!)
                for (_, post) in posts {
                    let parsedReplyPost = ParsedReplyPost()
                    parsedReplyPost.content = post["content"].string
                    let inputDateFormatter = DateFormatter()
                    inputDateFormatter.locale = Locale(identifier: "ja")
                    inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    let date: Date? = inputDateFormatter.date(from: post["created_at"].string!)
                    let outputDateFormatter = DateFormatter()
                    outputDateFormatter.dateFormat = "yyy/MM/dd HH:mm"
                    parsedReplyPost.createdAt = outputDateFormatter.string(from: date!)
                    if let avatarUrl = post["avatar_url"].string {
                        parsedReplyPost.avatarURL = URL(string: avatarUrl)
                    }
                    parsedReplyPost.nickname = post["nickname"].string
                    parsedReplyPost.title = post["title"].string
                    self.parsedReplyPosts.append(parsedReplyPost)
                }
                DispatchQueue.main.async(execute: { ()-> Void in self.tableView.reloadData() })
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
