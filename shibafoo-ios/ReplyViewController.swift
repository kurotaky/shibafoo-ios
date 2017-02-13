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
import Kingfisher

class ReplyViewController: UITableViewController {
    var parsedReplyPosts : Array <ParsedReplyPost> = []
    
    @IBAction func handleRefresh(_ sender: AnyObject?) {
        self.parsedReplyPosts.append(ParsedReplyPost(id: 1, content: "New row", createdAt: Date().description, avatarURL: defaultAvatarURL, nickname: "new", title: "title", lovesCount: 0, isLoved: "false", inReplyToUserName: "nickname"))
        reloadPosts()
        refreshControl!.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView() // フッターの線を消す
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
        return parsedReplyPosts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomPostCell") as? ParsedReplyPostCell
        let parsedReplyPost = parsedReplyPosts[(indexPath as NSIndexPath).row]
        cell?.contentTextView.text = parsedReplyPost.content
        cell?.createdAtLabel.text = parsedReplyPost.createdAt
        cell?.nicknameLabel.text = parsedReplyPost.nickname
        cell?.titleLabel.text = parsedReplyPost.title
        cell?.replyUserNicknameLabel.text = parsedReplyPost.inReplyToUserName
        var lovesCountText = "0 Love"
        if parsedReplyPost.lovesCount?.description != nil {
            lovesCountText = (parsedReplyPost.lovesCount?.description)! + " Love"
        }
        var lovedState: UIControlState = UIControlState.normal
        if (parsedReplyPost.isLoved != nil) {
            if parsedReplyPost.isLoved == "true" {
                cell?.lovesCount.isSelected = true
                lovedState = UIControlState.selected
            } else {
                cell?.lovesCount.isSelected = false
                lovedState = UIControlState.normal
            }
        }
        cell?.lovesCount.setTitle(lovesCountText, for: lovedState)
        if parsedReplyPost.avatarURL != nil {
            let url = URL(string: parsedReplyPost.avatarURL!.description)
            cell?.avatarImageView.kf.setImage(with: url)
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }
    
    func reloadPosts() {
        let userDefault = UserDefaults.standard
        
        if let token = userDefault.object(forKey: "authentication_token") as? String {
            if let email = userDefault.object(forKey: "email") as? String {
                let parameters: Parameters = ["email": email, "token": token]
                Alamofire.request(EndpointConst().URL + "api/posts/reply", parameters: parameters).responseJSON { response in
                    self.parsedReplyPosts.removeAll(keepingCapacity: true)
                    if let posts = response.result.value {
                        for post in posts as! [AnyObject] {
                            let parsedReplyPost = ParsedReplyPost()
                            parsedReplyPost.content = post["content"] as? String
                            let inputDateFormatter = DateFormatter()
                            inputDateFormatter.locale = Locale(identifier: "ja")
                            inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                            let date: Date? = inputDateFormatter.date(from: (post["created_at"] as? String)!)
                            let outputDateFormatter = DateFormatter()
                            outputDateFormatter.dateFormat = "yyy/MM/dd HH:mm"
                            parsedReplyPost.createdAt = outputDateFormatter.string(from: date!)
                            if let avatarUrl = post["avatar_url"] as? String {
                                parsedReplyPost.avatarURL = URL(string: avatarUrl)
                            }
                            parsedReplyPost.nickname = post["nickname"] as? String
                            parsedReplyPost.title = post["title"] as? String
                            parsedReplyPost.lovesCount = post["loves_count"] as? Int
                            parsedReplyPost.isLoved = post["is_loved"] as? String
                            parsedReplyPost.id = post["id"] as? Int
                            parsedReplyPost.inReplyToUserName = post["in_reply_to_user_name"] as? String
                            self.parsedReplyPosts.append(parsedReplyPost)
                        }
                        DispatchQueue.main.async(execute: { ()-> Void in self.tableView.reloadData() })
                    }
                }
            } else {
                // tokenがない場合はログイン画面を表示
                let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "LoginNavigationController") as? UINavigationController
                self.navigationController?.present(navigationController!, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func loveButtonDidPush(_ sender: UIButton) {
        let button = sender
        let view = button.superview!
        let cell = view.superview as! ParsedReplyPostCell
        let indexPath = self.tableView.indexPath(for: cell)
        let parsedReplyPost = self.parsedReplyPosts[(indexPath?.row)!]
        var lovesCount = 0
        if parsedReplyPost.lovesCount == nil {
            lovesCount = 0
        } else {
            lovesCount = parsedReplyPost.lovesCount!
        }
        let userDefault = UserDefaults.standard
        let email = userDefault.object(forKey: "email") as? String
        let token = userDefault.object(forKey: "authentication_token")
        let params = ["email": email!, "token": token!, "post_id": parsedReplyPost.id!]
        
        if sender.isSelected {
            Alamofire.request(EndpointConst().URL + "api/loves/unlove", method: .delete, parameters: params)
                .responseJSON { response in
                    if response.response?.statusCode == 200 {
                        if let data = response.result.value as? NSDictionary {
                            lovesCount = (data["loves_count"] as? Int)!
                            sender.isSelected = !sender.isSelected
                            let loveText = String(lovesCount) + " Love"
                            sender.setTitle(loveText, for: UIControlState.normal)
                        }
                    }
            }
        } else {
            Alamofire.request(EndpointConst().URL + "api/loves", method: .post, parameters: params)
                .responseJSON { response in
                    if response.response?.statusCode == 200 {
                        if let data = response.result.value as? NSDictionary {
                            lovesCount = (data["loves_count"] as? Int)!
                            sender.isSelected = !sender.isSelected
                            let loveText = String(lovesCount) + " Love"
                            sender.setTitle(loveText, for: UIControlState.selected)
                        }
                    }
            }
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let button: UIButton = sender as! UIButton
        let view = button.superview
        let cell = view?.superview as! ParsedReplyPostCell
        let indexPath = self.tableView.indexPath(for: cell)
        let parsedReplyPost = self.parsedReplyPosts[(indexPath?.row)!]
        if segue.identifier == "postView" {
            let postViewController: PostViewController = segue.destination as! PostViewController
            postViewController.parsedReplyPost = parsedReplyPost
        }
    }
}
