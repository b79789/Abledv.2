//
//  EnterReviewDataController.swift
//  Abled
//
//  Created by Brian Stacks on 1/15/16.
//  Copyright © 2016 Brian Stacks. All rights reserved.
//

import UIKit
import Parse
import Firebase
import FirebaseStorage

class EnterReviewDataController: UIViewController {
    
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeAddress: UITextField!
    @IBOutlet weak var placeType: UITextField!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var proPic: UIImageView!
    var ref:FIRDatabaseReference!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (FIRAuth.auth()?.currentUser) != nil {
            self.ref = FIRDatabase.database().referenceFromURL("https://stacksapp-7b63c.firebaseio.com/")
            self.ref.child("users").child(FIRAuth.auth()!.currentUser!.uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                // check if user has photo
                if snapshot.hasChild("userPhoto"){
                    // set image locatin
                    let filePath = "\(FIRAuth.auth()!.currentUser!.uid)/\("userPhoto")"
                    let storage = FIRStorage.storage()
                    let storageRef = storage.referenceForURL("gs://stacksapp-7b63c.appspot.com/image_data")
                    storageRef.child(filePath).dataWithMaxSize(20*1024*1024, completion: { (data, error) in
                        
                        let userPhoto = UIImage(data: data!)
                        self.proPic.image = userPhoto
                    })
                }else{
                    //let defImage = user.photoURL
                    let storage = FIRStorage.storage()
                    let storageRef = storage.referenceForURL("gs://stacksapp-7b63c.appspot.com/defaultImage/No_Image_Available.png")
                    storageRef.dataWithMaxSize(20*1024*1024, completion: { (data, error) in
                        
                        let userPhoto = UIImage(data: data!)
                        self.proPic.image = userPhoto
                    })
                    
                }
            })
        }
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