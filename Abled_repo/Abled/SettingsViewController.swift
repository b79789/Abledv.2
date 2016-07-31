//
//  SettingsViewController.swift
//  Abled
//
//  Created by Brian Stacks on 1/15/16.
//  Copyright © 2016 Brian Stacks. All rights reserved.
//

import UIKit
import Firebase


class SettingsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverPresentationControllerDelegate
  {
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var changePic: UIButton!
    @IBOutlet weak var contactDev: UIButton!
    @IBOutlet weak var themePick: UISegmentedControl!
    var picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        profilePic.image=info[UIImagePickerControllerOriginalImage] as? UIImage
        
        //let pickedImage:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //let imageData = UIImageJPEGRepresentation(pickedImage, 0.5)
//        let imageFile:PFFile = PFFile(data: imageData!)!
//        PFUser.currentUser()!.setObject(imageFile, forKey:"profilePic")
//        PFUser.currentUser()!.saveInBackground()
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        print("picker cancel.")
        
    }
    @IBAction func radiusAction(sender: AnyObject) {
        
        let popoverContent = (self.storyboard?.instantiateViewControllerWithIdentifier("radius"))! as UIViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSizeMake(200,200)
        popover!.delegate = self
        popover!.sourceView = self.view
        popover!.sourceRect = CGRectMake(self.view.frame.width/4, self.view.frame.height/4,0,0)
        
        self.presentViewController(nav, animated: true, completion: nil)
        
    }

    @IBAction func contactDevAction(sender: AnyObject) {
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if let user = FIRAuth.auth()?.currentUser {
            let name = user.displayName
            let email = user.email
            //let photoUrl = user.photoURL
            let uid = user.uid
            print(email , uid)
            if (name != nil) {
                self.userNameLabel.text = "User: " + name!
            }else{
                self.userNameLabel.text = "User: Updating..."
            }

        } else {
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(viewController, animated: true, completion: nil)
            })
            print("No user signed in")
        }
    }


}
