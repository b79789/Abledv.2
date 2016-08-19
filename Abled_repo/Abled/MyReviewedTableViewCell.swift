//
//  MyReviewedTableViewCell.swift
//  Abled
//
//  Created by Brian Stacks on 7/28/16.
//  Copyright © 2016 Brian Stacks. All rights reserved.
//

import UIKit

class MyReviewedTableViewCell: UITableViewCell {
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
