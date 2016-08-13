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


class AddPlaceVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource   {

    @IBOutlet weak var UnitTypePicker: UIPickerView!
    @IBOutlet weak var starRating: HCSStarRatingView!
    @IBOutlet weak var yourTextView: UITextView!
    @IBOutlet weak var addPicButton: UIButton!
    @IBOutlet weak var proPic: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeAddress: UITextField!
    var myPicker = UIImagePickerController()
    var ref:FIRDatabaseReference!
    var imgString: String!
    //Create an empty array
    var myArray: [String] = [String]()
    let storage = FIRStorage.storage()
    var finalRating: Double!
    var finalImage: UIImage!
    var finalURL: NSURL!
    var finalURLString: String!
    var testDBL = Double()
    var finalType: String!
    let UnitDataArray = [ "accounting", "airport","amusement_park","aquarium","art_gallery","atm","bakery","bank","bar","beauty_salon","bicycle_store","book_store","bowling_alley","bus_station","cafe","campground","car_dealer","car_rental","car_repair","car_wash","casino","cemetery","church","city_hall","clothing_store","convenience_store","courthouse","dentist","department_store","doctor","electrician","electronics_store","embassy","fire_station","florist","funeral_home","furniture_store","gas_station","gym","hair_care","hardware_store","hindu_temple","home_goods_store","hospital","insurance_agency","jewelry_store","laundry","lawyer","library","liquor_store","local_government_office","locksmith","lodging","meal_delivery","meal_takeaway","mosque","movie_rental","movie_theater","moving_company","museum","night_club","painter","park","parking","pet_store","pharmacy","physiotherapist","plumber","police","post_office","real_estate_agency","restaurant","roofing_contractor","rv_park","school","shoe_store","shopping_mall","spa","stadium","storage","store","subway_station","synagogue","taxi_stand","train_station","transit_station","travel_agency","university","veterinary_care","zoo","Other"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yourTextView.delegate = self
        yourTextView.text = "Add comments here..."
        yourTextView.textColor = UIColor.lightGrayColor()
        UnitTypePicker.delegate = self
        UnitTypePicker.dataSource = self

        if (FIRAuth.auth()?.currentUser) != nil {
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
                            self.proPic.image = userPhoto
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
                        self.proPic.image = userPhoto
                    })
                    
                }
            })
        }
        
        
    }
    
    
    @IBAction func ratingAction(sender: AnyObject) {
        self.finalRating = Double(starRating.value)
        print(self.finalRating.description)
       
    }
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        if yourTextView.textColor == UIColor.lightGrayColor() {
            yourTextView.text = ""
            yourTextView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        if yourTextView.text == "" {
            
            yourTextView.text = "Add comments here..."
            yourTextView.textColor = UIColor.lightGrayColor()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        myFunc()
        myFunc2()

    }
    
    @IBAction func fakeSave(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return UnitDataArray.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let myTypeString: String = UnitDataArray[row]
        self.finalType = myTypeString
    }
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: UnitDataArray[row], attributes: [NSForegroundColorAttributeName : UIColor.orangeColor()])
        return attributedString
    }
    
    
    @IBAction func saveAction(sender: AnyObject) {
         if (self.placeName.text == "" ){
            let alert = UIAlertController(title: "Name Error", message: "Please enter name.", preferredStyle: UIAlertControllerStyle.Alert);
            let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            alert.popoverPresentationController?.sourceView  = self.view
            alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.frame.width/4, self.view.frame.height/4,0,0)
            presentViewController(alert, animated: true, completion: nil);

        }else if (self.placeAddress.text == ""){
            let alert = UIAlertController(title: "Address Error", message: "Please enter address.", preferredStyle: UIAlertControllerStyle.Alert);
            let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            alert.popoverPresentationController?.sourceView  = self.view
            alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.frame.width/4, self.view.frame.height/4,0,0)
            presentViewController(alert, animated: true, completion: nil);
        }else if (self.finalRating == nil){
            let alert = UIAlertController(title: "Rating Error", message: "Please select rating.", preferredStyle: UIAlertControllerStyle.Alert);
            let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            alert.popoverPresentationController?.sourceView  = self.view
            alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.frame.width/4, self.view.frame.height/4,0,0)
            presentViewController(alert, animated: true, completion: nil);
            
        }else if(self.finalType == nil){
            let alert = UIAlertController(title: " Select Type Error", message: "Please select type.", preferredStyle: UIAlertControllerStyle.Alert);
            let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            alert.popoverPresentationController?.sourceView  = self.view
            alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.frame.width/4, self.view.frame.height/4,0,0)
            presentViewController(alert, animated: true, completion: nil);
            
        }else if (self.finalImage == nil){
            let alert = UIAlertController(title: "Image Error", message: "Please select image.", preferredStyle: UIAlertControllerStyle.Alert);
            let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            alert.popoverPresentationController?.sourceView  = self.view
            alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.frame.width/4, self.view.frame.height/4,0,0)
            presentViewController(alert, animated: true, completion: nil);

        }else if (self.yourTextView.text == nil){
            let alert = UIAlertController(title: "Comment Error", message: "Please add comment.", preferredStyle: UIAlertControllerStyle.Alert);
            let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            alert.popoverPresentationController?.sourceView  = self.view
            alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.frame.width/4, self.view.frame.height/4,0,0)
            presentViewController(alert, animated: true, completion: nil);

        }else{
         self.ref = FIRDatabase.database().referenceFromURL("https://abled-e36b6.firebaseio.com/")
            FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
                if let user = user {
                    
                    
                        //var messageRef: FIRDatabaseReference!
                        let name = self.placeName.text
                        let address = self.placeAddress.text
                        let type = self.finalType
                        let comments = self.yourTextView.text
                        var data = NSData()
                        data = UIImageJPEGRepresentation(self.finalImage, 0.8)!
                        // set upload path
                        self.ref = FIRDatabase.database().referenceFromURL("https://abled-e36b6.firebaseio.com/")
                        
                        let key = self.ref.child("user-posts").childByAutoId().key
                        let filePath = "\(FIRAuth.auth()!.currentUser!.uid)/\(key)\("user/posts/postImage")"
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
                                self.finalURLString = downloadURL
                                if (self.finalURLString != nil ) {
                                    let post: [NSObject : AnyObject] = ["uid": user.uid,"name": name!, "address": address!,"type": type, "image_path": self.finalURLString, "starCount": self.finalRating, "key": key, "placeComments": comments]
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
        
        }
    
    
    func myFunc() {
        let borderWidth:CGFloat = 2.0 // what ever border width do you prefer
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRectMake(0.0, placeName.frame.size.height  - borderWidth, self.view.frame.size.width, self.view.frame.size.height )
        bottomLine.backgroundColor = UIColor.grayColor().CGColor
        bottomLine
        placeName.layer.addSublayer(bottomLine)
        placeName.layer.masksToBounds = true
        
        
    }
    
    func myFunc2() {
        let borderWidth:CGFloat = 2.0 // what ever border width do you prefer
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRectMake(0.0, placeAddress.frame.size.height  - borderWidth, self.view.frame.size.width, self.view.frame.size.height )
        bottomLine.backgroundColor = UIColor.grayColor().CGColor
        bottomLine
        placeAddress.layer.addSublayer(bottomLine)
        placeAddress.layer.masksToBounds = true
        
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
        self.addPicButton.setImage(tempImage, forState: .Normal)
        self.finalImage = tempImage
        self.finalURL = localFile

    }
    


    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
