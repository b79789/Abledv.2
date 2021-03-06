//
//  SignUpViewController.swift
//  Abled
//
//  Created by Brian Stacks on 1/14/16.
//  Copyright © 2016 Brian Stacks. All rights reserved.
//

import Foundation
import UIKit
import Parse
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var reEnterPass: UITextField!
    var ref:FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().referenceFromURL("https://abled-e36b6.firebaseio.com/")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signUpAction(sender: AnyObject) {
        print("Hit Sign Up")
        let username = self.usernameField.text
        let password = self.passwordField.text
        let email = self.emailField.text
        let repass = self.reEnterPass.text
        
        if username?.characters.count < 5 {
            let alert = UIAlertController(title: "Invalid", message: "Username must be greater than 5 characters", preferredStyle: UIAlertControllerStyle.Alert);
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            showViewController(alert, sender: self);
        }else if email?.characters.count < 8 {
            let alert = UIAlertController(title: "Invalid", message: "Please enter a valid email address", preferredStyle: UIAlertControllerStyle.Alert);
            showViewController(alert, sender: self);
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
        }else if password?.characters.count < 6 {
            let alert = UIAlertController(title: "Invalid", message: "Password must be greater than 6 characters", preferredStyle: UIAlertControllerStyle.Alert);
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            showViewController(alert, sender: self);
        }else if (password !=  repass){
            let alert = UIAlertController(title: "Invalid", message: "Passwords are not the same, please re-enter", preferredStyle: UIAlertControllerStyle.Alert);
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            showViewController(alert, sender: self);
        } else {
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            
            
            FIRAuth.auth()?.createUserWithEmail(email!, password: password!) { (user, error) in
                
                if (error != nil) {
                    let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                    self.showViewController(alert, sender: self);}))
                } else {
                    let user = FIRAuth.auth()?.currentUser
                    if let user = user {
                        let changeRequest = user.profileChangeRequest()
                        
                        changeRequest.displayName = username
                        changeRequest.photoURL =
                            NSURL(string: "gs://stacksapp-7b63c.appspot.com/defaultImage/")
                        changeRequest.commitChangesWithCompletion { error in
                            if error != nil {
                                // An error happened.
                                print("error updating")
                            } else {
                                // Profile updated.
                                print("updated", username)
                                self.ref.child("users").child(FIRAuth.auth()!.currentUser!.uid).updateChildValues(["userName": username!, "userID": user.uid, "userPhoto": (user.photoURL?.absoluteString)!])
                                
                            }
                        }
                    }
                    spinner.stopAnimating()
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
                        self.presentViewController(viewController, animated: true, completion: nil)
                    })
                }
                
            }

        }
    }

    
}
