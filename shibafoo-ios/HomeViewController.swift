//
//  HomeViewController.swift
//  shibafoo-ios
//
//  Created by usr0600244 on 2015/09/01.
//  Copyright (c) 2015年 mo-fu. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UITableViewController {

    var parsedPosts : Array <ParsedPost> = [
        ParsedPost(content:"shibafoo!!!! ", createdAt:"2015-08-20 16:44:30 JST"),
        ParsedPost(content:"シバフだ!", createdAt:"2015-08-22 10:44:30 JST"),
        ParsedPost(content:"こんにちは〜", createdAt:"2015-08-30 12:44:30 JST")
    ]

    @IBAction func handleRefresh(sender: AnyObject?) {
        self.parsedPosts.append(ParsedPost(content: "New row", createdAt: NSDate().description))
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
        return cell!
    }

    func reloadPosts() {
        // AlamofireとかでAPI叩いて値を取得
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