//
//  EnterReviewDataController.swift
//  Abled
//
//  Created by Brian Stacks on 1/15/16.
//  Copyright © 2016 Brian Stacks. All rights reserved.
//

import UIKit
import Parse


class EnterReviewDataController: UIViewController {
    
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeAddress: UITextField!
    @IBOutlet weak var placeType: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        myFunc()
        myFunc2()
        myFunc3()
    }
    
    func myFunc() {
        let borderWidth:CGFloat = 2.0 // what ever border width do you prefer
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRectMake(0.0, placeName.frame.size.height  - borderWidth, placeName.frame.size.width, placeName.frame.size.height )
        bottomLine.backgroundColor = UIColor.grayColor().CGColor
        bottomLine
        placeName.layer.addSublayer(bottomLine)
        placeName.layer.masksToBounds = true
        
        
    }
    
    func myFunc2() {
        let borderWidth:CGFloat = 2.0 // what ever border width do you prefer
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRectMake(0.0, placeAddress.frame.size.height  - borderWidth, placeAddress.frame.size.width, placeAddress.frame.size.height )
        bottomLine.backgroundColor = UIColor.grayColor().CGColor
        bottomLine
        placeAddress.layer.addSublayer(bottomLine)
        placeAddress.layer.masksToBounds = true
        
    }
    func myFunc3() {
        let borderWidth:CGFloat = 2.0 // what ever border width do you prefer
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRectMake(0.0, placeType.frame.size.height  - borderWidth, placeType.frame.size.width, placeType.frame.size.height )
        bottomLine.backgroundColor = UIColor.grayColor().CGColor
        bottomLine
        placeType.layer.addSublayer(bottomLine)
        placeType.layer.masksToBounds = true
        
    }
    
}