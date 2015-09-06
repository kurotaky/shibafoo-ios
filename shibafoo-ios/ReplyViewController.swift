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
    
    @IBAction func handleRefresh(sender: AnyObject?) {
        self.parsedReplyPosts.append(ParsedReplyPost(content: "New row", createdAt: NSDate().description, avatarURL: defaultAvatarURL, nickname: "new", title: "title"))
        reloadPosts()
        refreshControl!.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "ReFoo!"
        reloadPosts()
        var refresher = UIRefreshControl()
        refresher.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refresher
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedReplyPosts.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomReplyPostCell") as? ParsedReplyPostCell
        let parsedReplyPost = parsedReplyPosts[indexPath.row]
        cell?.contentLabel.text = parsedReplyPost.content
        cell?.createdAtLabel.text = parsedReplyPost.createdAt
        cell?.nicknameLabel.text = parsedReplyPost.nickname
        cell?.titleLabel.text = parsedReplyPost.title
        if parsedReplyPost.avatarURL != nil {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                {() -> Void in
                    let avatarImage = UIImage(data: NSData (
                        contentsOfURL: parsedReplyPost.avatarURL!)!)
                    dispatch_async(dispatch_get_main_queue(),
                        {
                            cell?.avatarImageView.image = avatarImage
                    })
                }
            )
            cell?.avatarImageView.image = UIImage (data: NSData(contentsOfURL: parsedReplyPost.avatarURL!)!)
        }
        return cell!
    }

    func reloadPosts() {
        let userDefault = NSUserDefaults.standardUserDefaults()
        let token = userDefault.objectForKey("authentication_token") as? String
        let email = userDefault.objectForKey("email") as? String
        Alamofire.request(.GET, "http://www.shibafoo.com/api/posts/reply", parameters: ["email": email!, "token": token!]).responseJSON { _, _, data, _ in
            self.parsedReplyPosts.removeAll(keepCapacity: true)
            if let jsonData: AnyObject = data {
                let posts = JSON(jsonData)
                for (key, post) in posts {
                    let parsedReplyPost = ParsedReplyPost()
                    parsedReplyPost.content = post["content"].string
                    let inputDateFormatter = NSDateFormatter()
                    inputDateFormatter.locale = NSLocale(localeIdentifier: "ja")
                    inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    let date: NSDate? = inputDateFormatter.dateFromString(post["created_at"].string!)
                    let outputDateFormatter = NSDateFormatter()
                    outputDateFormatter.dateFormat = "yyy/MM/dd HH:mm"
                    parsedReplyPost.createdAt = outputDateFormatter.stringFromDate(date!)
                    if let avatarUrl = post["avatar_url"].string {
                        parsedReplyPost.avatarURL = NSURL(string: avatarUrl)
                    }
                    parsedReplyPost.nickname = post["nickname"].string
                    parsedReplyPost.title = post["title"].string
                    self.parsedReplyPosts.append(parsedReplyPost)
                }
                dispatch_async(dispatch_get_main_queue(), { ()-> Void in self.tableView.reloadData() })
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
