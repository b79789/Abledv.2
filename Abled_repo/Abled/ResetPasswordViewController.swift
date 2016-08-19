//
//  ResetPasswordViewController.swift
//  Abled
//
//  Created by Brian Stacks on 1/14/16.
//  Copyright © 2016 Brian Stacks. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func passwordReset(sender: AnyObject) {
        
        
        let email = self.emailField.text
        let finalEmail = email!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if (email != nil || email == FIRAuth.auth()?.currentUser?.email) {
            FIRAuth.auth()?.sendPasswordResetWithEmail(email!) { error in
                if let error = error {
                    let alert = UIAlertController (title: "Password Reset Error", message: "An error has been detected : " +  error.debugDescription, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                        alert.dismissViewControllerAnimated(true, completion: nil)
                    }))
                    self.showViewController(alert, sender: self);
                } else {
                    let alert = UIAlertController (title: "Password Reset", message: "An email containing information on how to reset your password has been sent to " + finalEmail + ".", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                        alert.dismissViewControllerAnimated(true, completion: nil)
                    }))
                    self.showViewController(alert, sender: self);            }
            }
            
        }
    }
    
}
