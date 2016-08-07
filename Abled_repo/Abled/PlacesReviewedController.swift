//
//  PlacesReviewedController.swift
//  Abled
//
//  Created by Brian Stacks on 1/15/16.
//  Copyright © 2016 Brian Stacks. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class PlacesReviewController: UIViewController, UITableViewDelegate, UITableViewDataSource
 {
    @IBOutlet weak var proPic: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    var ref:FIRDatabaseReference!
    var myReviewedArray: [Posts]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "customcell")
        if let user = FIRAuth.auth()?.currentUser {
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
    
    func fireBaseFunc() {
        self.ref = FIRDatabase.database().referenceFromURL("https://stacksapp-7b63c.firebaseio.com/user-posts")
        self.ref.queryOrderedByChild("starCount").observeEventType(.Value, withBlock: { snapshot in
            if snapshot.exists(){
                for child in snapshot.children{
                    for items in child.children{
                        let myName = items.value["name"] as! String
   
                        let myAdd = items.value["address"] as! String
                        let type = items.value["type"] as! String
                        let urlString = items.value["image_path"] as! String
                        let rating = items.value["starCount"] as! Double
                        let myPost = Posts(name: myName, address: myAdd, type: type, rating: rating, url: urlString)
                        
                        self.myReviewedArray.append(myPost)
                        self.myTableView.reloadData()
                    }
                }
            }
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if let user = FIRAuth.auth()?.currentUser {
            let name = user.displayName
            //let email = user.email
            //let photoUrl = user.photoURL
            //let uid = user.uid
            
            
            if (name != nil) {
                self.userNameLabel.text = "User: " + name!
            }else{
                self.userNameLabel.text = "User: Updating..."
            }
            self.myTableView.reloadData()
        } else {
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(viewController, animated: true, completion: nil)
            })
            print("No user signed in")
        }

        
    }

   
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if self.myReviewedArray == nil {
            var myPost = Posts(name: "No Data",address: "No Data",type: "No Data",rating: 0,url: "No Data")
            self.myReviewedArray = [myPost]
            return self.myReviewedArray.count
        }else{
        return self.myReviewedArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PlacesReviewed") as! MyReviewedTableViewCell
        if let user = FIRAuth.auth()?.currentUser {
            self.ref = FIRDatabase.database().referenceFromURL("https://stacksapp-7b63c.firebaseio.com/")
            self.ref.child("posts").child(FIRAuth.auth()!.currentUser!.uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                
                if snapshot.hasChild("-KOay46uft4DPa_ZTTlP"){
                    // set image locatin
                    let filePath = "\(FIRAuth.auth()!.currentUser!.uid)/\("image_data")"
                    let storage = FIRStorage.storage()
                    let storageRef = storage.referenceForURL("gs://stacksapp-7b63c.appspot.com/")
                    storageRef.child(filePath).dataWithMaxSize(20*1024*1024, completion: { (data, error) in
                        
                        let userPhoto = UIImage(data: data!)
                        cell.cellImage.image = userPhoto
                    })
                }else{
                    //let defImage = user.photoURL
                    let storage = FIRStorage.storage()
                    let storageRef = storage.referenceForURL("gs://stacksapp-7b63c.appspot.com/defaultImage/No_Image_Available.png")
                    storageRef.dataWithMaxSize(20*1024*1024, completion: { (data, error) in
                        
                        let userPhoto = UIImage(data: data!)
                        cell.cellImage.image = userPhoto
                    })
                    
                }
            })
        }
        if self.myReviewedArray == nil {
            let myPost = Posts(name: "No Data",address: "No Data",type: "No Data",rating: 0,url: "No Data")
            self.myReviewedArray = [myPost]
            cell.nameLabel.text = self.myReviewedArray[indexPath.item].Name
            cell.nameLabel.adjustsFontSizeToFitWidth = true
            cell.addressLabel.text = self.myReviewedArray[indexPath.item].Address
            cell.addressLabel.adjustsFontSizeToFitWidth = true
            
        }else{
            cell.nameLabel.text = self.myReviewedArray[indexPath.item].Name
            cell.nameLabel.adjustsFontSizeToFitWidth = true
            cell.addressLabel.text = self.myReviewedArray[indexPath.item].Address
            cell.addressLabel.adjustsFontSizeToFitWidth = true
        }
        
        //cell.cellImage.image = UIImage(named: thumbils[indexPath.row])
        
        //cell.addressLabel.text = addressArray[indexPath.item]
        //cell.addressLabel.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        print("Row: \(row)")
        
        print(self.myReviewedArray[row] )
        
    }
    
     func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
}
