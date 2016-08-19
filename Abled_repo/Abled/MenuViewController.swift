//
//  MenuViewController.swift
//  Abled
//
//  Created by Brian Stacks on 7/27/16.
//  Copyright © 2016 Brian Stacks. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var messageUserButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func followAction(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("refresh2", object: nil)
        self.dismissViewControllerAnimated(true, completion: nil)

    }

    @IBAction func messageAction(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil)
        self.dismissViewControllerAnimated(true, completion: nil)

        
        
    }
    
    @IBAction func cancelFunc(sender: AnyObject){
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
