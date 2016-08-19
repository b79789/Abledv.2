//
//  ProfileTable.swift
//  Abled
//
//  Created by Brian Stacks on 8/14/16.
//  Copyright © 2016 Brian Stacks. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class ProfileTable: UITableViewController ,UINavigationControllerDelegate , UIImagePickerControllerDelegate{
    @IBOutlet weak var mainProfileImage: UIImageView!
    @IBOutlet weak var editName: UIImageView!
    @IBOutlet weak var editEmail: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var resetPassButton: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var reEamil: UITextField!
    @IBOutlet weak var rePass: UITextField!
    var ref:FIRDatabaseReference!
    var picker = UIImagePickerController()
    var editTextFieldToggle: Bool = false
    var followersArray: [Users]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameText.enabled = false
        self.emailText.enabled = false
        let tempImageView = UIImageView(image: UIImage(named: "open-road.jpg"))
        tempImageView.alpha = 0.5
        tempImageView.frame = self.tableView.frame
        self.tableView.backgroundView = tempImageView;
        if (FIRAuth.auth()?.currentUser) != nil{
            let user = FIRAuth.auth()?.currentUser
            let name = user!.displayName
            let email = user!.email
            let photoUrl = user!.photoURL
            nameText.text = name
            emailText.text = email
            if let url = photoUrl {
                if let data = NSData(contentsOfURL: url) {
                    mainProfileImage.image = UIImage(data: data)
                }
            }
            self.ref = FIRDatabase.database().referenceFromURL("https://abled-e36b6.firebaseio.com/")
            self.ref.child("users").child(FIRAuth.auth()!.currentUser!.uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                // check if user has photo
                if snapshot.hasChild("userPhoto"){
                    // set image locatin
                    let filePath = "\(FIRAuth.auth()!.currentUser!.uid)/\("userPhoto")"
                    let storage = FIRStorage.storage()
                    let storageRef = storage.referenceForURL("gs://abled-e36b6.appspot.com/image_data")
                    storageRef.child(filePath).dataWithMaxSize(20*1024*1024, completion: { (data, error) in
                        
                        if (data != nil){
                            let userPhoto = UIImage(data: data!)
                            self.mainProfileImage.image = userPhoto
//                            self.proPic.image = userPhoto
                        }else{
                            print(error.debugDescription)
                        }
                    })
                }else{
                    //let defImage = user.photoURL
                    let storage = FIRStorage.storage()
                    let storageRef = storage.referenceForURL("gs://abled-e36b6.appspot.com/defaultImage/No_Image_Available.png")
                    storageRef.dataWithMaxSize(20*1024*1024, completion: { (data, error) in
                        
                        let userPhoto = UIImage(data: data!)
                        self.mainProfileImage.image = userPhoto
//                        self.proPic.image = userPhoto
                    })
                    
                }
            })
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        
        editName.userInteractionEnabled = true
        editEmail.userInteractionEnabled = true
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfileTable.singleTapping(_:)))
        singleTap.numberOfTapsRequired = 1;
        editName.addGestureRecognizer(singleTap)
        let singleTap2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfileTable.singleTapping2(_:)))
        singleTap2.numberOfTapsRequired = 1;
        editEmail.addGestureRecognizer(singleTap2)
        let imageView = self.mainProfileImage
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(ProfileTable.changePicAction(_:)))
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        circularImage(mainProfileImage)
        let myString = "https://abled-e36b6.firebaseio.com//users//" + (FIRAuth.auth()?.currentUser?.uid)! + "//followers"
        let myRef = FIRDatabase.database().referenceFromURL(myString)
        myRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if snapshot.exists(){
                self.followersArray = [Users]()
                for snap in snapshot.children{
                    
                    for child in snap.children{
                        let myName = child.value["Name"] as! String
                        let myID = child.value["UID"] as! String
                        let myURL = child.value["URL"] as! String
                        let users = Users()
                        users.name = myName
                        users.id = myID
                        users.url = NSURL(string: myURL)!
                        
                        self.followersArray.append(users)
                        
                        self.setFollowButtton()
                    }
                    
                }
                
            }
            
        })
            
        
        
        
    }
    
    func setFollowButtton(){
        self.followersButton.setTitle("Followed: " + self.followersArray.count.description, forState: .Normal)
        print(self.followersArray.count.description)
    }
    
    
    @IBAction func resetAction(sender: AnyObject) {
        let email = emailText.text
        
        FIRAuth.auth()?.sendPasswordResetWithEmail(email!) { error in
            if let error = error {
                let alert = UIAlertController (title:"Error", message: "\(error)",preferredStyle: UIAlertControllerStyle.Alert);
                self.presentViewController(alert, animated: false, completion: {
                    sleep(3)
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        alert.dismissViewControllerAnimated(true, completion: nil)
                    })
                })
            } else {
                let alert = UIAlertController(title: "Email Success", message: "Email has been set to " + email!, preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(alert, animated: false, completion: {
                    sleep(1)
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        alert.dismissViewControllerAnimated(true, completion: nil)
                    })
                })
                
            }
        }
    }
    
    @IBAction func followersAction(sender: AnyObject) {
        
        print("hit followers")
    }
    
    func singleTapping(recognizer: UIGestureRecognizer) {
        editTextFieldToggle = !editTextFieldToggle //switches button ON/OFF
        
        if editTextFieldToggle == true {
            textFieldActive()
            nameText.allowsEditingTextAttributes = true
            nameText.becomeFirstResponder()
            
        } else {
            textFieldDeactive()
            
        }
    }
    
    func singleTapping2(recognizer: UIGestureRecognizer) {
        editTextFieldToggle = !editTextFieldToggle //switches button ON/OFF
        
        if editTextFieldToggle == true {
            textFieldActive2()
            emailText.allowsEditingTextAttributes = true
            emailText.becomeFirstResponder()
            
        } else {
            textFieldDeactive2()
            
        }
    }
    
    func textFieldActive(){
    nameText.enabled = true
    
    }
    
    func textFieldDeactive(){
    nameText.enabled = false
    
    }
    
    func textFieldActive2(){
        emailText.enabled = true
    }
    
    func textFieldDeactive2(){
        emailText.enabled = false
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
    
    @IBAction func saveAction(sender: AnyObject) {
        if (self.nameText.text != nil || self.emailText.text != nil) {
            let user = FIRAuth.auth()?.currentUser
            if let user = user {
                let changeRequest = user.profileChangeRequest()
                
                changeRequest.displayName = self.nameText.text
                user.updateEmail(self.emailText.text!) { error in
                    if let error = error {
                        print(error.description)
                        // An error happened.
                        let alert = UIAlertController(title: "Sign-in", message: "You must revalidate your credentials", preferredStyle:
                            UIAlertControllerStyle.Alert)
                        alert.addTextFieldWithConfigurationHandler(self.configurationTextField)
                        alert.addTextFieldWithConfigurationHandler(self.configurationTextField2)
                        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
                        alert.addAction(UIAlertAction(title: "Signin", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
                            print("userclicked Signin")
                            FIRAuth.auth()?.signInWithEmail(alert.textFields![0].text!, password: alert.textFields![1].text!){ (user, error) in
                                // ...
                                if ((user) != nil) {
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        let alert = UIAlertController(title: "Updated email", message: "Email up to date.", preferredStyle: UIAlertControllerStyle.Alert)
                                        self.presentViewController(alert, animated: false, completion: {
                                            sleep(1)
                                            dispatch_async(dispatch_get_main_queue(), {
                                                
                                                alert.dismissViewControllerAnimated(true, completion: nil)
                                            })
                                        })
                                    })
                                    
                                } else {
                                    let alert = UIAlertController (title:"Error", message: "\(error)",preferredStyle: UIAlertControllerStyle.Alert);
                                    self.presentViewController(alert, animated: false, completion: {
                                        sleep(3)
                                        dispatch_async(dispatch_get_main_queue(), {
                                            
                                            alert.dismissViewControllerAnimated(true, completion: nil)
                                        })
                                    })
                                    
                                }
                            }
                        }))

                    } else {
                        // Email updated.
                        changeRequest.commitChangesWithCompletion { error in
                            if let error = error {
                                print(error.description)
                                // An error happened.
                                let alert = UIAlertController(title: "Updated Failed", message: "You are not up to date.", preferredStyle: UIAlertControllerStyle.Alert)
                                self.presentViewController(alert, animated: false, completion: {
                                    sleep(3)
                                    dispatch_async(dispatch_get_main_queue(), {
                                        
                                        alert.dismissViewControllerAnimated(true, completion: nil)
                                    })
                                })
                            } else {
                                // Profile updated.
                                let alert = UIAlertController(title: "Updated Success", message: "You are up to date.", preferredStyle: UIAlertControllerStyle.Alert)
                                self.presentViewController(alert, animated: false, completion: {
                                    sleep(3)
                                    dispatch_async(dispatch_get_main_queue(), {
                                        
                                        alert.dismissViewControllerAnimated(true, completion: nil)
                                    })
                                })
                                
                            }
                        }
                    }
                }
                
            }
       }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // Change the color of all cells
        //cell.backgroundColor = UIColor.clearColor()
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header :UITableViewHeaderFooterView = UITableViewHeaderFooterView()
        
        header.contentView.backgroundColor = UIColor.lightGrayColor()
        return header
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
    
    @IBAction func changePicAction(sender: AnyObject) {
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
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
        alert.popoverPresentationController?.sourceView  = self.view
        alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.frame.width/4, self.view.frame.height/4,0,0)
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(picker, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: UIAlertControllerStyle.Alert);
            showViewController(alert, sender: self);
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
        }
    }
    func openGallary(){
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    //MARK:UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        picker .dismissViewControllerAnimated(true, completion: nil)
        mainProfileImage.image=info[UIImagePickerControllerOriginalImage] as? UIImage
        
        let pickedImage:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        _ = UIImagePNGRepresentation(pickedImage)
        mainProfileImage.image = pickedImage
        dismissViewControllerAnimated(true, completion: nil)
        var data = NSData()
        data = UIImageJPEGRepresentation(mainProfileImage.image!, 0.8)!
        // set upload path
        let filePath = "\(FIRAuth.auth()!.currentUser!.uid)/\("userPhoto")"
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpg"
        let storage = FIRStorage.storage()
        let storageRef = storage.referenceForURL("gs://abled-e36b6.appspot.com/image_data")
        storageRef.child(filePath).putData(data, metadata: metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                //store downloadURL
                let downloadURL = metaData!.downloadURL()!.absoluteString
                //store downloadURL at database
                self.ref = FIRDatabase.database().referenceFromURL("https://abled-e36b6.firebaseio.com/")
                self.ref.child("users").child(FIRAuth.auth()!.currentUser!.uid).updateChildValues(["userPhoto": downloadURL])
            }
            
        }
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        print("picker cancel.")
        
    }
    
    @IBAction func logOutAction(sender: AnyObject){
        
        // Send a request to log out a user
        try! FIRAuth.auth()!.signOut()
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
            self.presentViewController(viewController, animated: true, completion: nil)
        })
        
    }
    
    

}
