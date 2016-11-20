//
//  ParsedPost.swift
//  shibafoo-ios
//
//  Created by usr0600244 on 2015/09/02.
//  Copyright (c) 2015年 mo-fu. All rights reserved.
//

import UIKit

class ParsedPost: NSObject {
    var content: String?
    var nickname: String?
    var title: String?
    var avatarURL: URL?
    var lovesCount: Int?
    var isLoved: String?
    // リプライ数
    var createdAt: String?
    
    init(content: String?, createdAt: String?, avatarURL: URL?, nickname: String?, title: String, lovesCount: Int?, isLoved: String?) {
        super.init()
        self.content = content
        self.nickname = nickname
        self.title = title
        self.lovesCount = lovesCount
        self.isLoved = isLoved
        self.createdAt = createdAt
        self.avatarURL = avatarURL
    }
    
    override init() {
        super.init()
        self.content = ""
        self.nickname = ""
        self.title = ""
        self.lovesCount = 0
        self.isLoved = ""
        self.createdAt = ""
        self.avatarURL = nil
    }
}
