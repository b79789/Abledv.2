//
//  AddPlaceVC.swift
//  Abled
//
//  Created by Brian Stacks on 8/2/16.
//  Copyright © 2016 Brian Stacks. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import Photos

class AddPlaceVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate   {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addPicButton: UIButton!
    @IBOutlet weak var proPic: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeAddress: UITextField!
    @IBOutlet weak var placeType: UITextField!
    var myPicker = UIImagePickerController()
    var ref:FIRDatabaseReference!
    var imgString: String!
    //Create an empty array
    var myArray: [String] = [String]()
    let storage = FIRStorage.storage()
    var cosmosView: CosmosView!
    var finalRating: Double!
    var finalImage: UIImage!
    var finalURL: NSURL!
    var finalURLString: String!
    
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
    
    @IBAction func fakeSave(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func saveAction(sender: AnyObject) {
         self.ref = FIRDatabase.database().referenceFromURL("https://stacksapp-7b63c.firebaseio.com/")
        if (self.finalRating == nil){
            self.finalRating = 0
        }
            FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
                if let user = user {
                    if self.placeName.text != nil || self.placeAddress != nil || self.placeType != nil || self.finalImage != nil{
                        
                        //var messageRef: FIRDatabaseReference!
                        let name = self.placeName.text
                        let address = self.placeAddress.text
                        let type = self.placeType.text
                        var data = NSData()
                        data = UIImageJPEGRepresentation(self.finalImage, 0.8)!
                        // set upload path
                        let filePath = "\(FIRAuth.auth()!.currentUser!.uid)/\("user/posts/postImage")"
                        let metaData = FIRStorageMetadata()
                        metaData.contentType = "image/jpg"
                        let storage = FIRStorage.storage()
                        let storageRef = storage.referenceForURL("gs://stacksapp-7b63c.appspot.com/image_data")
                        storageRef.child(filePath).putData(data, metadata: metaData){(metaData,error) in
                            if let error = error {
                                print(error.localizedDescription)
                                return
                            }else{
                                //store downloadURL
                                let downloadURL = metaData!.downloadURL()!.absoluteString
                                //store downloadURL at database
                                self.ref = FIRDatabase.database().referenceFromURL("https://stacksapp-7b63c.firebaseio.com/")
                                self.finalURLString = downloadURL
                                let key = self.ref.child("user-posts").childByAutoId().key
                                if (self.finalURLString != nil ) {
                                    let post: [NSObject : AnyObject] = ["uid": user.uid,"name": name!, "address": address!,"type": type!, "image_path": self.finalURLString, "starCount": self.finalRating, "key": key]
                                    let childUpdates = ["/posts/\(key)": post,
                                        "/user-posts/)\(user.uid)/\(key)": post]
                                    self.ref.updateChildValues(childUpdates)
                                    let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PlacesReviewed") as! PlacesReviewController
                                    self.navigationController?.pushViewController(secondViewController, animated: true)
                                }else{
                                    
                                    let alert = UIAlertController(title: "Invalid Image", message: "Corrupted Image Retry", preferredStyle: UIAlertControllerStyle.Alert);
                                    UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
                                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                                        alert.dismissViewControllerAnimated(true, completion: nil)
                                    }))
                                    self.showViewController(alert, sender: self);
                                }
                                
                            }
                            }
                            
                        }
                        
                } else {
                    // No user is signed in.
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
                        self.presentViewController(viewController, animated: true, completion: nil)
                    })
                    print("No user signed in")
                }
            }
            
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
        myPicker.delegate = self
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
            myPicker.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(myPicker, animated: true, completion: nil)
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
        myPicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        self.presentViewController(myPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker .dismissViewControllerAnimated(true, completion: nil)
        let tempImage:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let localFile: NSURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        self.imageView.image = tempImage
        self.finalImage = tempImage
        self.finalURL = localFile
//        let imageName = localFile.path! as NSString
//        imageName.lastPathComponent
//        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as String
//        let localPath = NSURL(fileURLWithPath: documentDirectory).URLByAppendingPathComponent(imageName as String)
//        let imageData: NSData = UIImagePNGRepresentation(tempImage)!
//        imageData.writeToFile(localPath.absoluteString , atomically: true)
//        let assets = PHAsset.fetchAssetsWithALAssetURLs([localFile], options: nil)
//        let asset = assets.firstObject
//        asset?.requestContentEditingInputWithOptions(nil, completionHandler: { (contentEditingInput, info) in
//            let imageFile = contentEditingInput?.fullSizeImageURL
//            self.imgString = imageFile?.absoluteString
//            let storageRef = self.storage.referenceForURL("gs://stacksapp-7b63c.appspot.com/image_data")
//            let uploadTask = storageRef.putFile(imageFile!, metadata: nil) { metadata, error in
//                if (error != nil) {
//                    // Uh-oh, an error occurred!
//                } else {
//                    // Metadata contains file metadata such as size, content-type, and download URL.
//                    let downloadURL = metadata!.downloadURL
//                    
//                    
//                }
//            }
//            uploadTask.resume()
//        })
        

    }
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
//        picker .dismissViewControllerAnimated(true, completion: nil)
//        imageView.image=image
//        
//        let localFile: NSURL = UIImagePNGRepresentation(image)!
//        let data: NSData = UIImagePNGRepresentation(image)!
//        let strBase64:String = data.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
//        self.imgString = strBase64.utf8
//        let storageRef = storage.referenceForURL("gs://stacksapp-7b63c.appspot.com/image_data")
//        let uploadTask = storageRef.putFile(localFile, metadata: nil) { metadata, error in
//            if (error != nil) {
//                // Uh-oh, an error occurred!
//            } else {
//                // Metadata contains file metadata such as size, content-type, and download URL.
//               let downloadURL = metadata!.downloadURL
//                
//            }
//        }
//        uploadTask.resume()
//    }
//    

    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
