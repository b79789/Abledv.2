//
//  FollowedView.swift
//  Abled
//
//  Created by Brian Stacks on 8/17/16.
//  Copyright © 2016 Brian Stacks. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class FollowedView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var myArray = ["Me "," You"]
    var ref:FIRDatabaseReference!
    var userArray = [Users]()
    @IBOutlet weak var myTableView: UITableView!
    var myImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fireBaseFunc()
        
    }
    
    func fireBaseFunc() {
        let id = (FIRAuth.auth()?.currentUser?.uid)! as String
        self.ref = FIRDatabase.database().referenceFromURL("https://abled-e36b6.firebaseio.com/users/" + id + "/followers")
        self.ref.queryOrderedByValue().observeEventType(.Value, withBlock: { snapshot in
            
            if snapshot.exists(){
                
                for snap in snapshot.children{
                    for child in snap.children{
                        let name = child.value["Name"] as? String
                        let id = child.value["UID"] as? String
                        let url = child.value["URL"] as? String
                        let users = Users()
                        users.name = name!
                        users.id = id!
                        users.url = NSURL(string: url!)!
                        self.userArray.append(users)
                        self.myTableView.reloadData()
                        
                        
                    }
                    
                }
            }
            
            
        })
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
    return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    return userArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! FollwedTableViewCell
        cell.nameLabel.text = userArray[indexPath.row].name
        let url =  userArray[indexPath.row].url
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let data = NSData(contentsOfURL: url) //make sure your image in this url does exist, otherwise unwrap in a if let check
            dispatch_async(dispatch_get_main_queue(), {
                cell.userImage.image = UIImage(data: data!)
            });
        }
        
        //cell.userImage.image = UIImage(
        //cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
}



