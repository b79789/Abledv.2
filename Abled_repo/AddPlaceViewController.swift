//
//  AddPlaceViewController.swift
//  Abled
//
//  Created by Brian Stacks on 1/15/16.
//  Copyright © 2016 Brian Stacks. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class AddPlaceViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addPicButton: UIButton!
    @IBOutlet weak var proPic: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeAddress: UITextField!
    @IBOutlet weak var placeType: UITextField!
    var picker = UIImagePickerController()
    
    //Create an empty array
    var myArray: [String] = [String]()
    
    @IBAction func fakeSave(sender: AnyObject) {
        
       self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        if let currentUser = FIRAuth.auth()?.currentUser {
            if self.placeName.text != nil || self.placeAddress != nil || self.placeType != nil{
        
                let ref = FIRDatabase.database().referenceFromURL("https://stacksapp-7b63c.firebaseio.com/")
                //var messageRef: FIRDatabaseReference!
                
                
                let userName = ["userName" : currentUser.displayName as! AnyObject]
                let userEmail = ["userEmail" : currentUser.email as! AnyObject]
                
                let name = self.placeName.text
                let address = self.placeAddress.text
                let type = self.placeType.text
        
                let usersRef = ref.child("users")
                let userPlace = ref.child("userPlaces")
        
                let places = ["placeName": name as! AnyObject, "placeAddress": address as! AnyObject, "placeType"
            : type as! AnyObject]
        
                let users = ["userName": userName, "userEmail": userEmail]
                usersRef.setValue(users)
                userPlace.setValue(places)
                usersRef.child("userName").setValue(userName)
                usersRef.child("userEmail").setValue(userEmail)
        
                let hopperRef = usersRef.child(currentUser.displayName!)
                let addMore = ["Reviewed": "Yes"]
                hopperRef.updateChildValues(addMore)
                
            }
            
        }
        //if let currentUser = FIRAuth.auth()?.currentUser {
            
//        if let currentUser = PFUser.currentUser() {
//            
//            currentUser.fetchIfNeededInBackgroundWithBlock({ (foundUser: PFObject?, error: NSError?) -> Void in
//                
//                // Get and update user added data
//                
//                if foundUser != nil {
//                    if self.placeName.text != nil || self.placeAddress != nil{
//                    let name = self.placeName.text
//                    let address = self.placeAddress.text
//                    let type = self.placeType.text
//                    let userPlaces = PFObject(className:"userPlaces")
//                        userPlaces["placeName"] = name
//                        userPlaces["placeAddress"] = address
//                        userPlaces["userName"] = currentUser.username
//                        userPlaces["placeType"] = type
//                        userPlaces.saveInBackground()
//                        
//                        
//                    foundUser!["placeName"] = name
//                    foundUser!["placeAddress"] = address
//                    
//                    foundUser?.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
//                        
//                        if succeeded {
//                            
//                            print("place details added to user")
//                            print(name)
//                            print(address)
//                        }
//                    })
//                    
//                }
//                
//                }
//            })
//                
//            
//     }
//    
//        
//               let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PlacesReviewed");
//               self.navigationController!.pushViewController(viewController, animated: true)
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

    }
    
  override func viewWillAppear(animated: Bool) {
    
    
//        if let user = FIRAuth.auth()?.currentUser {
//            let name = user.displayName
//            let email = user.email
//            //let photoUrl = user.photoURL
//            let uid = user.uid
//            print(email , uid)
//            if (name != nil) {
//                self.userNameLabel.text = "User: " + name!
//            }else{
//                self.userNameLabel.text = "User: Updating..."
//            }
//            
//        } else {
//            
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
//                self.presentViewController(viewController, animated: true, completion: nil)
//            })
//            print("No user signed in")
//        }
//
  }

    @IBAction func savePicAction(sender: AnyObject) {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.modalPresentationStyle = .Popover
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.Default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
        {
            UIAlertAction in
        }
        
        
        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = addPicButton
            presenter.sourceRect = addPicButton.bounds
        }
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(picker, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "Warning", message: "You don't have camera",preferredStyle: UIAlertControllerStyle.Alert);
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            showViewController(alert, sender: self);
        }
    }
    func openGallary()
    {
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        picker .dismissViewControllerAnimated(true, completion: nil)
        imageView.image=info[UIImagePickerControllerOriginalImage] as? UIImage
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        print("picker cancel.")
    }

    
}