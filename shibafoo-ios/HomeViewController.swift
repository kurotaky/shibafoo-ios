//
//  HomeViewController.swift
//  shibafoo-ios
//
//  Created by usr0600244 on 2015/09/01.
//  Copyright (c) 2015年 mo-fu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

let defaultAvatarURL = NSURL(string: "https://pbs.twimg.com/profile_images/479609750007468033/8YeHnMJk.jpeg")

class HomeViewController: UITableViewController {

    var parsedPosts : Array <ParsedPost> = [
        ParsedPost(content:"shibafoo!!!! ", createdAt:"2015-08-20 16:44:30 JST", avatarURL: defaultAvatarURL),
        ParsedPost(content:"シバフだ!", createdAt:"2015-08-22 10:44:30 JST", avatarURL: defaultAvatarURL),
        ParsedPost(content:"こんにちは〜", createdAt:"2015-08-30 12:44:30 JST", avatarURL: defaultAvatarURL)
    ]

    @IBAction func handleRefresh(sender: AnyObject?) {
        self.parsedPosts.append(ParsedPost(content: "New row", createdAt: NSDate().description, avatarURL: defaultAvatarURL))
        reloadPosts()
        refreshControl!.endRefreshing()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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

//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Section \(section)"
//    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedPosts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomPostCell") as? ParsedPostCell
        let parsedPost = parsedPosts[indexPath.row]
        cell?.contentLabel.text = parsedPost.content
        cell?.createdAtLabel.text = parsedPost.createdAt
        if parsedPost.avatarURL != nil {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                {() -> Void in
                    let avatarImage = UIImage(data: NSData (
                        contentsOfURL: parsedPost.avatarURL!)!)
                    dispatch_async(dispatch_get_main_queue(),
                        {
                            //if cell.userNameLabel.text == parsedPost.userName {
                                cell?.avatarImageView.image = avatarImage
                            //} else {
                            //    println("oops, wrong cell, never mind")
                            //}
                    })
                }
            )
            cell?.avatarImageView.image = UIImage (data: NSData(contentsOfURL: parsedPost.avatarURL!)!)
        }
        return cell!
    }

    func reloadPosts() {
        Alamofire.request(.GET, "http://localhost:3000/api/posts").responseJSON { _, _, data, _ in
            self.parsedPosts.removeAll(keepCapacity: true)
            if let jsonData: AnyObject = data {
                let posts = JSON(jsonData)
                for (key, post) in posts {
                    let parsedPost = ParsedPost()
                    parsedPost.content = post["content"].string
                    // 作成時刻を変換。あとで処理を外に切り出す
                    let inputDateFormatter = NSDateFormatter()
                    inputDateFormatter.locale = NSLocale(localeIdentifier: "ja")
                    inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    let date: NSDate? = inputDateFormatter.dateFromString(post["created_at"].string!)
                    let outputDateFormatter = NSDateFormatter()
                    outputDateFormatter.dateFormat = "yyy/MM/dd HH:mm"
                    parsedPost.createdAt = outputDateFormatter.stringFromDate(date!)
                    // default画像を入れておく
                    parsedPost.avatarURL = defaultAvatarURL
                    self.parsedPosts.append(parsedPost)
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