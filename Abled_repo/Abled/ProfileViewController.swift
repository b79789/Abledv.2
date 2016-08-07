//
//  ProfileViewController.swift
//  Abled
//
//  Created by Brian Stacks on 7/27/16.
//  Copyright © 2016 Brian Stacks. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage



class ProfileViewController: UIViewController {
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var passWord: UITextField!
    @IBOutlet weak var Follow: UIButton!
    @IBOutlet weak var EditProfile: UIButton!
    @IBOutlet weak var deleteProfile: UIButton!
    @IBOutlet weak var reEamil: UITextField!
    @IBOutlet weak var rePass: UITextField!
    var ref:FIRDatabaseReference!
    
    var launchBool: Bool = false {
        didSet {
            if launchBool == true {
                
                EditProfile.setTitle("Save Profile", forState: .Normal)
                //setInfo()
                self.userName.userInteractionEnabled = true
                self.email.userInteractionEnabled = true
                self.passWord.userInteractionEnabled = true
                self.userName.textColor = UIColor.grayColor()
                self.email.textColor = UIColor.grayColor()
                self.passWord.textColor = UIColor.grayColor()
            } else {
                saveProfile()
                EditProfile.setTitle("Edit Profile", forState: .Normal)
                self.userName.userInteractionEnabled = false
                self.email.userInteractionEnabled = false
                self.passWord.userInteractionEnabled = false
                self.userName.textColor = UIColor.orangeColor()
                self.email.textColor = UIColor.orangeColor()
                self.passWord.textColor = UIColor.orangeColor()
                
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        circularImage(profilePic)
        getProfileInfo()
        if let user = FIRAuth.auth()?.currentUser {
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
                        self.profilePic.image = userPhoto
                    })
                }else{
                    //let defImage = user.photoURL
                    let storage = FIRStorage.storage()
                    let storageRef = storage.referenceForURL("gs://stacksapp-7b63c.appspot.com/defaultImage/No_Image_Available.png")
                    storageRef.dataWithMaxSize(20*1024*1024, completion: { (data, error) in
                        
                        let userPhoto = UIImage(data: data!)
                        self.profilePic.image = userPhoto
                    })
                    
                }
            })
        }

        

    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        //setInfo()
    }
    @IBAction func editProfile(sender: AnyObject) {
        
        
        launchBool = !launchBool
    }
    
    func configurationTextField(textField: UITextField!)
    {
        if textField != nil {
            self.reEamil = textField
            self.reEamil.placeholder = "User Email"
        }
    }
    
    func configurationTextField2(textField: UITextField!)
    {
        if textField != nil {
            self.rePass = textField
            self.rePass.secureTextEntry = true
            self.rePass.placeholder = "password"
        }
    }
    
    func saveProfile(){
        
        if (self.userName.text != nil || self.email.text != nil || self.passWord.text != nil) {
            if let user = FIRAuth.auth()?.currentUser {
                    let changeRequest = user.profileChangeRequest()
                    user.updateEmail(self.email.text!, completion: { error in
                    if error != nil {
                        let alert = UIAlertController(title: "Sign-in", message: "You must revalidate your credentials", preferredStyle:
                            UIAlertControllerStyle.Alert)
                        
                        alert.addTextFieldWithConfigurationHandler(self.configurationTextField)
                        alert.addTextFieldWithConfigurationHandler(self.configurationTextField2)
                        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
                        alert.addAction(UIAlertAction(title: "Signin", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
                            print("userclicked Signin")
                            
                        }))
                        
                        self.presentViewController(alert, animated: true, completion: {
                            print("completion block")
                        })
                        
                        
                        print(error.debugDescription)
                    } else {
                        // Email updated.
                        print("email updated")
                    }
                })
                
                user.updatePassword(self.passWord.text!) { error in
                    if error != nil {
                        let alert = UIAlertController(title: "Sign-in", message: "You must revalidate your credentials", preferredStyle:
                            UIAlertControllerStyle.Alert)
                        
                        alert.addTextFieldWithConfigurationHandler(self.configurationTextField)
                        alert.addTextFieldWithConfigurationHandler(self.configurationTextField2)
                        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
                        alert.addAction(UIAlertAction(title: "Signin", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
                            print("userclicked Signin")
                            
                        }))
                        
                        self.presentViewController(alert, animated: true, completion: {
                            print("completion block")
                        })
                        print(error.debugDescription )
                    } else {
                        print("password updated")
                    }
                }
                    changeRequest.displayName = self.userName.text
                    changeRequest.photoURL = NSURL(fileURLWithPath: "https://firebasestorage.googleapis.com/v0/b/stacksapp-7b63c.appspot.com/o/image_data?alt=media&token=03ac79da-736c-4904-90d9-b0eaefde2541")
                    changeRequest.commitChangesWithCompletion { error in
                        if let _ = error {
                            print("Try Again")
                        } else {
                            print("Photo Updated")
                            //let downloadURL =  user.photoURL
                            let photoURL = user.photoURL
                            struct last {
                                static var photoURL: NSURL? = nil
                            }
                            last.photoURL = photoURL;
                            if let photoURL = photoURL {
                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                                    let data = NSData.init(contentsOfURL: photoURL)
                                    if let data = data {
                                        let image = UIImage.init(data: data)
                                        dispatch_async(dispatch_get_main_queue(), {
                                            if (photoURL == last.photoURL) {
                                                self.profilePic.image = image
                                            }
                                        })
                                    }
                                })
                            } else {
                                self.profilePic.image = UIImage.init(named: "user-3.png")
                                print("Did not finish userPhoto")
                            }
                                //self.profilePic.image  = UIImage(data: NSData(contentsOfURL: downloadURL!)!)
            
                        }
                    }
            }
        }else{
            
        }
    }
    
    
    
    func reCheckCreds(){
        let credential = FIREmailPasswordAuthProvider.credentialWithEmail(self.reEamil.text!, password: self.passWord.text!)
        if let user = FIRAuth.auth()?.currentUser {
        user.reauthenticateWithCredential(credential) { error in
            if error != nil {
                print(error.debugDescription)
            } else {
                print("Credentials updated")
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        }
    }

    func getProfileInfo() {
        
        if let user = FIRAuth.auth()?.currentUser {
            
            let name = user.displayName
            let email = user.email
            let photoUrl = user.photoURL
            self.userName.text = name
            self.email.text = email
            let uid = user.uid;  // The user's ID, unique to the Firebase project.
            print([name, email, photoUrl?.absoluteString, uid])
//            let changeRequest = user.profileChangeRequest()
//            changeRequest.photoURL = NSURL(fileURLWithPath: "https://firebasestorage.googleapis.com/v0/b/stacksapp-7b63c.appspot.com/o/image_data?alt=media&token=03ac79da-736c-4904-90d9-b0eaefde2541")
//            changeRequest.commitChangesWithCompletion { error in
//                if let _ = error {
//                    print("Try Again")
//                } else {
//                    print("Photo Updated")
//                    let downloadURL =  user.photoURL
//                    //self.profilePic.image  = UIImage(data: NSData(contentsOfURL: downloadURL!)!)
//                    
//                }
//            }
            //self.profilePic.image = UIImage(data: imageUrl!)
            
        } else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(viewController, animated: true, completion: nil)
            })
            print("No user signed in")
        }
    }
    
    func setInfo(){
        let storage = FIRStorage.storage()
        let storageRef = storage.referenceForURL("gs://stacksapp-7b63c.appspot.com/image_data")
        let uploadTask = storageRef.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
            if (error != nil) {
                // Uh-oh, an error occurred!
            } else {
                // Data for "images/island.jpg" is returned
                 let myImage: UIImage! = UIImage(data: data!)
                self.profilePic.image = myImage
            }
        }
        uploadTask.resume()
        launchBool = true
   
    }

    func circularImage(photoImageView: UIImageView?)
    {
        photoImageView!.layer.frame = CGRectInset(photoImageView!.layer.frame, 0, 0)
        photoImageView!.layer.borderColor = UIColor.grayColor().CGColor
        photoImageView!.layer.cornerRadius = photoImageView!.frame.height/2
        photoImageView!.layer.masksToBounds = false
        photoImageView!.clipsToBounds = true
        photoImageView!.layer.borderWidth = 0.5
        photoImageView!.contentMode = UIViewContentMode.ScaleToFill
    }

}
