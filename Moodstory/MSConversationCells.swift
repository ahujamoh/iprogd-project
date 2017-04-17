//
//  MSConversationCells.swift
//  Moodstory
//
//  Created by Mohit on 09/04/17.
//  Copyright © 2017 MoodStory. All rights reserved.
//

import Foundation
import UIKit


class MSSenderCell: UITableViewCell {
    
    @IBOutlet weak var profilePic: RoundedImageView!
    
    @IBOutlet weak var message: UITextView!
    
    @IBOutlet weak var messageBackground: UIImageView!
    
    func clearCellData()  {
        self.message.text = nil
        self.message.isHidden = false
        self.messageBackground.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.message.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
        self.messageBackground.layer.cornerRadius = 15
        self.messageBackground.clipsToBounds = true
    }
}

class MSReceiverCell: UITableViewCell {
    
    @IBOutlet weak var message: UITextView!
    
    @IBOutlet weak var messageBackground: UIImageView!
    
    func clearCellData()  {
        self.message.text = nil
        self.message.isHidden = false
        self.messageBackground.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.message.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
        self.messageBackground.layer.cornerRadius = 15
        self.messageBackground.clipsToBounds = true
    }
}

class MSContactsCVCell: UICollectionViewCell {
    
    @IBOutlet weak var profilePic: RoundedImageView?
    
    @IBOutlet weak var nameLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
