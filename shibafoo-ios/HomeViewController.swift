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

let defaultAvatarURL = URL(string: "https://shibafoo.s3.amazonaws.com/uploads/user_profile/avatar/1/45eb7049-93d5-4d6f-84da-dd233cbfb06a.jpg")

class HomeViewController: UITableViewController {

    var parsedPosts : Array <ParsedPost> = []

    @IBAction func handleRefresh(_ sender: AnyObject?) {
        self.parsedPosts.append(ParsedPost(content: "New row", createdAt: Date().description, avatarURL: defaultAvatarURL, nickname: "new", title: "title"))
        reloadPosts()
        refreshControl!.endRefreshing()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "みんなのログ"
        reloadPosts()
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(HomeViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
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
        return parsedPosts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomPostCell") as? ParsedPostCell
        let parsedPost = parsedPosts[(indexPath as NSIndexPath).row]
        cell?.contentLabel.text = parsedPost.content
        cell?.createdAtLabel.text = parsedPost.createdAt
        cell?.nicknameLabel.text = parsedPost.nickname
        cell?.titleLabel.text = parsedPost.title
        if parsedPost.avatarURL != nil {
            var optData:Data? = nil
            do {
                optData = try Data(contentsOf: parsedPost.avatarURL! as URL, options: NSData.ReadingOptions.mappedIfSafe)
            }
            catch {
                print("Handle \(error) here")
            }
            if let data = optData {
                DispatchQueue.global().async(execute: {() -> Void in
                        let avatarImage = UIImage(data: data)
                        DispatchQueue.main.async(execute: {
                                cell?.avatarImageView.image = avatarImage
                        })
                    }
                )
                cell?.avatarImageView.image = UIImage(data: data)
            }
        }
        return cell!
    }
    
    func reloadPosts() {
        // Alamofire.request(.GET, "http://localhost:3000/api/posts").responseJSON { _, _, data, _ in
        Alamofire.request("https://shibafoo-shibafoo.sqale.jp/api/posts.json").responseJSON { response in
            self.parsedPosts.removeAll(keepingCapacity: true)
            if let posts = response.result.value {
                for post in posts as! [AnyObject] {
                    let parsedPost = ParsedPost()
                    parsedPost.content = post["content"] as? String
                    let inputDateFormatter = DateFormatter()
                    inputDateFormatter.locale = Locale(identifier: "ja")
                    inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    let date: Date? = inputDateFormatter.date(from: (post["created_at"] as? String)!)
                    let outputDateFormatter = DateFormatter()
                    outputDateFormatter.dateFormat = "yyy/MM/dd HH:mm"
                    parsedPost.createdAt = outputDateFormatter.string(from: date!)
                    if let avatarUrl = post["avatar_url"] as? String {
//                        parsedPost.avatarURL = NSURL(string: avatarUrl)
                        parsedPost.avatarURL = URL(string: avatarUrl)
                    }
                    parsedPost.nickname = post["nickname"] as? String
                    parsedPost.title = post["title"] as? String
                    self.parsedPosts.append(parsedPost)
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
