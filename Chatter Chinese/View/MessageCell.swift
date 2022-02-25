//
//  MessageCell.swift
//  Chatter Chinese
//
//  Created by Nelson Aquino Jr  on 2/19/22.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var leftBubble: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        leftBubble.layer.cornerRadius = messageBubble.frame.size.height/3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
