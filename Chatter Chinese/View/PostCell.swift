//
//  PostCell.swift
//  Chatter Chinese
//
//  Created by Nelson Aquino Jr  on 2/20/22.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var votes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
