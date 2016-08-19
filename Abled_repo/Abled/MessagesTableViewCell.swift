//
//  MessagesTableViewCell.swift
//  Abled
//
//  Created by Brian Stacks on 7/24/16.
//  Copyright © 2016 Brian Stacks. All rights reserved.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {
    @IBOutlet weak var profilersImage: UIImageView!
    @IBOutlet weak var messageText: UITextView!
    @IBOutlet weak var profilersName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
