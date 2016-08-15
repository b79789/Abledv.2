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
    var ref:FIRDatabaseReference!
    var picker = UIImagePickerController()
    var editTextFieldToggle: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
    }
    @IBAction func resetAction(sender: AnyObject) {
        print("hit reset")
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
        
        print(" Name image clicked")
    }
    func singleTapping2(recognizer: UIGestureRecognizer) {
        emailText.allowsEditingTextAttributes = true
        print(" Email image clicked")
    }
    
    func textFieldActive(){
    //Turn things ON
    nameText.enabled = true
    emailText.enabled = true
    }
    
    func textFieldDeactive(){
        //Add anything else
    //Turn things OFF
    nameText.enabled = false
    emailText.enabled = false
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
    
    

}
