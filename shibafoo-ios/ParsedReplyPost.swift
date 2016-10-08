//
//  ParsedReplyPost.swift
//  shibafoo-ios
//
//  Created by usr0600244 on 2015/09/06.
//  Copyright (c) 2015年 mo-fu. All rights reserved.
//

import UIKit

class ParsedReplyPost: NSObject {
    var content: String?
    var nickname: String?
    var title: String?
    var avatarURL: URL?
    // ラブされた数
    // リプライ数
    var createdAt: String?
    
    init(content: String?, createdAt: String?, avatarURL: URL?, nickname: String?, title: String) {
        super.init()
        self.content = content
        self.nickname = nickname
        self.title = title
        self.createdAt = createdAt
        self.avatarURL = avatarURL
    }
    
    override init() {
        super.init()
        self.content = ""
        self.nickname = ""
        self.title = ""
        self.createdAt = ""
        self.avatarURL = nil
    }
}
