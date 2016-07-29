//
//  HomeViewController.swift
//  Abled
//
//  Created by Brian Stacks on 1/14/16.
//  Copyright © 2016 Brian Stacks. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class HomeViewController: UIViewController , UIPopoverPresentationControllerDelegate
{
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var proPic: UIImageView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var messageName: UILabel!
    
    
    let pic1 =  "pic1.jpeg"
    let pic2 = "pic2.jpeg"
    let pic3 = "pic3.jpeg"
    let pic4 = "pic4.jpeg"
    let pic5 = "pic5.jpeg"
    let pic6 = "pic6.jpegf"
    let pic7 =  "pic7.jpeg"
    let pic8 =  "pic8.jpeg"
    let pic9 =  "pic9.jpeg"
    let pic10 = "pic10.jpeg"
    let testArray = ["Jonny","Wilma","Dusty","Brian78","Ronald","Vickie","Nicole", "Isaiah", "Tony", "Ashlie"]
    let commentArray = ["Very easy access to streets and businesses. I would recommend this part of the city to any mobility impaired users as the transitions are easy and access is plenty. I truly enjoyed myself here.","Smooth","easy in easy out","Not very accessible","Hope more places are like this","Would recommend","Excellent place", "Smooth transitions", "Beautiful and easy", "Exits and entrances are good"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
               }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            print(email,uid)
        } else {

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(viewController, animated: true, completion: nil)
            })
            print("No user signed in")
        }
        
        
    }
    
    @IBAction func profileClickButton(sender: AnyObject) {
        
        let popoverContent = (self.storyboard?.instantiateViewControllerWithIdentifier("Menu"))! as UIViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSizeMake(400,200)
        popover!.delegate = self
        popover!.sourceView = self.view
        popover!.sourceRect = CGRectMake(self.view.frame.width/2, self.view.frame.height/2,0,0)
        
        self.presentViewController(nav, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func logOutAction(sender: AnyObject){
        
        // Send a request to log out a user
        try! FIRAuth.auth()!.signOut()
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
            self.presentViewController(viewController, animated: true, completion: nil)
        })
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return testArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeTableViewCell") as! HomeTableViewCell
        let thumbils:[String] = [ pic1,pic2,pic3,pic4,pic5,pic6,pic7,pic8,pic9,pic10]
        cell.myImageView?.image = UIImage(named: thumbils[indexPath.row])
        //cell.myUserName?.text = testArray[indexPath.item]
        cell.myTextView?.text = commentArray[indexPath.item]
        cell.postersName?.text = testArray[indexPath.item]
        //cell.myUserName?.text = testArray[indexPath.item]
        //cell.textLabel?.text = testArray[indexPath.item]
        //cell.imageView?.image = UIImage(named: thumbils[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        print("Row: \(row)")
        
        print(testArray[row] )
        
        //let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("EnterData");
        //self.navigationController!.pushViewController(viewController, animated: true)
        
    }
    
}
