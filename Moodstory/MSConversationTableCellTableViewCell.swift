//
//  MSConversationTableCellTableViewCell.swift
//  Moodstory
//
//  Created by Mohit on 13/04/17.
//  Copyright © 2017 MoodStory. All rights reserved.
//

import UIKit

//class MSConversationsTBCell: UITableViewCell {
//
//    @IBOutlet weak var profilePic: RoundedImageView!
//
//    @IBOutlet weak var nameLabel: UILabel!
//
//    @IBOutlet weak var messageLabel: UILabel!
//
//    @IBOutlet weak var timeLabel: UILabel!
//    func clearCellData()  {
//        self.nameLabel.font = UIFont(name:"AvenirNext-Regular", size: 17.0)
//        self.messageLabel.font = UIFont(name:"AvenirNext-Regular", size: 14.0)
//        self.timeLabel.font = UIFont(name:"AvenirNext-Regular", size: 13.0)
//        self.profilePic.layer.borderColor = GlobalVariables.purple.cgColor
//        self.messageLabel.textColor = UIColor.rbg(r: 111, g: 113, b: 121)
//    }
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.profilePic.layer.borderWidth = 2
//        self.profilePic.layer.borderColor = GlobalVariables.purple.cgColor
//    }
//
//}
class MSConversationTableCellTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var profilePic: RoundedImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    
    func clearCellData()  {
        self.nameLabel.font = UIFont(name:"AvenirNext-Regular", size: 17.0)
        self.messageLabel.font = UIFont(name:"AvenirNext-Regular", size: 14.0)
        self.timeLabel.font = UIFont(name:"AvenirNext-Regular", size: 13.0)
        self.profilePic.layer.borderColor = GlobalVariables.purple.cgColor
        self.messageLabel.textColor = UIColor.rbg(r: 111, g: 113, b: 121)
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//        self.profilePic.layer.borderWidth = 2
//        self.profilePic.layer.borderColor = GlobalVariables.purple.cgColor
//    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
