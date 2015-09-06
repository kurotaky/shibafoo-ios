//
//  ParsedReplyPostCell.swift
//  shibafoo-ios
//
//  Created by usr0600244 on 2015/09/06.
//  Copyright (c) 2015年 mo-fu. All rights reserved.
//

import UIKit

class ParsedReplyPostCell: UITableViewCell {
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}