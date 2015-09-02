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
    // var userName: String?
    var createdAt: String?
    
    init(content: String?, createdAt: String?) {
        super.init()
        self.content = content
        self.createdAt = createdAt
    }
    
    override init() {
        super.init()
        self.content = ""
        self.createdAt = ""
    }
}