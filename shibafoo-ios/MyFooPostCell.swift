//
//  MyFooPostCell.swift
//  shibafoo-ios
//
//  Created by usr0600244 on 2016/11/24.
//  Copyright © 2016年 mo-fu. All rights reserved.
//


import UIKit

class MyFooPostCell: UITableViewCell {
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lovesCount: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
