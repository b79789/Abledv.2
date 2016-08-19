//
//  FollwedTableViewCell.swift
//  Abled
//
//  Created by Brian Stacks on 8/17/16.
//  Copyright © 2016 Brian Stacks. All rights reserved.
//

import UIKit

class FollwedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
