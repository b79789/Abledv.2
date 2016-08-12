//
//  DetailView.swift
//  Abled
//
//  Created by Brian Stacks on 1/21/16.
//  Copyright © 2016 Brian Stacks. All rights reserved.
//

import UIKit
import Parse


class DetailView: UIViewController {
    
    @IBOutlet weak var proPic: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeAddress: UILabel!
    @IBOutlet weak var placePhoto: UIImageView!
    @IBOutlet weak var placeComments: UITextView!
    
    var nameString = String()
    var addString = String()
    var commentstext = String()
    var ratingPassed = Double()
    var imageString = UIImage()
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBAction func CloseAction(sender: AnyObject) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home")
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.placeName.text = nameString
        self.placeAddress.text = addString
        print("comment:" + ratingPassed.description)
        self.placePhoto.image = imageString
        self.placeComments.text = commentstext
        
    }
    
    
    
    
}