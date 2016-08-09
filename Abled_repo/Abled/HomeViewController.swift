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
import FirebaseDatabase
import FirebaseStorage

class HomeViewController: UIViewController , UIPopoverPresentationControllerDelegate
{
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var proPic: UIImageView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var messageName: UILabel!
    var ref:FIRDatabaseReference!
    var reviewedArray: [Posts]!
    var myImage: UIImage!
    var imageArray: [UIImage]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        if (FIRAuth.auth()?.currentUser) != nil {
            fireBaseFunc()
            self.ref = FIRDatabase.database().referenceFromURL("https://stacksapp-7b63c.firebaseio.com/")
            self.ref.child("users").child(FIRAuth.auth()!.currentUser!.uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                // check if user has photo
                if snapshot.hasChild("userPhoto"){
                    // set image locatin
                    let filePath = "\(FIRAuth.auth()!.currentUser!.uid)/\("userPhoto")"
                    let storage = FIRStorage.storage()
                    let storageRef = storage.referenceForURL("gs://stacksapp-7b63c.appspot.com/image_data")
                    storageRef.child(filePath).dataWithMaxSize(20*1024*1024, completion: { (data, error) in
                        if (data == nil){
                            print(error.debugDescription)
                        }else{
                            let userPhoto = UIImage(data: data!)
                            self.proPic.image = userPhoto
                        }
                        
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
    

    func fireBaseFunc() {
        self.imageArray = [UIImage]()
        self.reviewedArray = [Posts]()
        self.ref = FIRDatabase.database().referenceFromURL("https://stacksapp-7b63c.firebaseio.com/user-posts")
        self.ref.queryOrderedByChild("key").observeEventType(.Value, withBlock: { snapshot in
            if snapshot.exists(){
                for child in snapshot.children{
                    
                    for item in child.children{
                        let myName = item.value["name"] as! String
                        
                        let myAdd = item.value["address"] as! String
                        let type = item.value["type"] as! String
                        let urlString = item.value["image_path"] as! String
                        let rating = item.value["starCount"] as! Double
                        let myPost = Posts(name: myName, address: myAdd, type: type, rating: rating, url: urlString)
                        let storage = FIRStorage.storage()
                        storage.referenceForURL(urlString).dataWithMaxSize(20*1024*1024, completion: { (data, error) in
                            if(error == nil){
                               
                                let userPhoto = UIImage(data: data!)
                                self.imageArray.append(userPhoto!)
                                self.reviewedArray.append(myPost)
                                self.myTableView.reloadData()
                                //self.myImage = userPhoto
                                //cell.cellImage.image = userPhoto
                                
                            }else{
                                print(error.debugDescription)
                            }
                        })
                        
                    }
                    
                }
            }
        })
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
    
    @IBAction func profileClickButton(sender: AnyObject) {
        
        let popoverContent = (self.storyboard?.instantiateViewControllerWithIdentifier("Menu"))! as UIViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSizeMake(self.view.frame.width/2, self.view.frame.height/2)
        popover!.delegate = self
        popover!.sourceView = self.view
        popover!.sourceRect = CGRectMake(self.view.frame.width/2, self.view.frame.height/2,0,0)
        
        self.navigationController!.presentViewController(nav, animated: true, completion: nil)
        
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
        if self.reviewedArray == nil {
            let myPost = Posts(name: "No Data",address: "No Data",type: "No Data",rating: 0,url: "No Data")
            self.reviewedArray = [myPost]
            return self.reviewedArray.count
        }else{
            return self.reviewedArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeTableViewCell") as! HomeTableViewCell
        //let thumbils:[String] = [ pic1,pic2,pic3,pic4,pic5,pic6,pic7,pic8,pic9,pic10]
        if self.reviewedArray == nil {
            let myPost = Posts(name: "No Data",address: "No Data",type: "No Data",rating: 0,url: "No Data")
            self.reviewedArray = [myPost]
            cell.postersName.text = self.reviewedArray[indexPath.item].Name
            cell.postersName.adjustsFontSizeToFitWidth = true
            cell.myTextView.text = self.reviewedArray[indexPath.item].Address
            cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
            cell.imageView?.clipsToBounds = true
            cell.imageView?.image = self.imageArray[indexPath.item]
            
        }else{
            cell.postersName.text = self.reviewedArray[indexPath.item].Name
            cell.postersName.adjustsFontSizeToFitWidth = true
            cell.myTextView.text = self.reviewedArray[indexPath.item].Address
            
            cell.imageView?.image = self.imageArray[indexPath.item]

            cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
            cell.imageView?.clipsToBounds = true
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        print("Row: \(row)")
        
        print(self.reviewedArray[row] )
        
        //let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("EnterData");
        //self.navigationController!.pushViewController(viewController, animated: true)
        
    }
    
}
