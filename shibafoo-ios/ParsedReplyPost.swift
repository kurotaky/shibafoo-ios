//
//  ParsedReplyPost.swift
//  shibafoo-ios
//
//  Created by usr0600244 on 2015/09/06.
//  Copyright (c) 2015年 mo-fu. All rights reserved.
//

import UIKit

class ParsedReplyPost: NSObject {
    var id: Int?
    var content: String?
    var nickname: String?
    var title: String?
    var avatarURL: URL?
    var lovesCount: Int?
    var isLoved: String?
    var inReplyToUserName: String?
    var createdAt: String?
    
    init(id: Int?, content: String?, createdAt: String?, avatarURL: URL?, nickname: String?, title: String, lovesCount: Int?, isLoved: String?, inReplyToUserName: String?) {
        super.init()
        self.id = id
        self.content = content
        self.nickname = nickname
        self.title = title
        self.lovesCount = lovesCount
        self.isLoved = isLoved
        self.inReplyToUserName = inReplyToUserName
        self.createdAt = createdAt
        self.avatarURL = avatarURL
    }
    
    override init() {
        super.init()
        self.id = 1
        self.content = ""
        self.nickname = ""
        self.title = ""
        self.lovesCount = 0
        self.isLoved = ""
        self.inReplyToUserName = ""
        self.createdAt = ""
        self.avatarURL = nil
    }
}
