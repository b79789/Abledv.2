//
//  HomeTableViewCell.swift
//  Abled
//
//  Created by Brian Stacks on 7/24/16.
//  Copyright © 2016 Brian Stacks. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    @IBOutlet var myImageView: UIImageView!
    @IBOutlet var myTextView: UITextView!
    @IBOutlet weak var myUserName: UILabel!
    @IBOutlet weak var postersName: UILabel!
    @IBOutlet weak var placeAddress: UILabel!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var userRating: HCSStarRatingView!
    @IBOutlet weak var shareButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

}
