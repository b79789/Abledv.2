//
//  MessagesViewController.swift
//  Abled
//
//  Created by Brian Stacks on 7/24/16.
//  Copyright © 2016 Brian Stacks. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class MessagesViewController: UIViewController {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var proPic: UIImageView!
    var ref:FIRDatabaseReference!
    let testArray = ["Jonny","Wilma","Dusty","Brian78","Ronald","Vickie","Nicole", "Isaiah", "Tony", "Ashlie"]
    let commentArray = ["Very easy access","Smooth","easy in easy out","Not very accessible","Hope more places are like this","Would recommend","Excellent place", "Smooth transitions", "Beautiful and easy", "Exits and entrances are good"]
    let pic1 = "man1.jpeg"
    let pic2 = "wman1.jpeg"
    let pic3 = "man2.jpeg"
    let pic4 = "man3.jpeg"
    let pic5 = "man4.jpeg"
    let pic6 = "wman2.jpegf"
    let pic7 = "wman3.jpeg"
    let pic8 = "man5.jpeg"
    let pic9 = "man6.jpeg"
    let pic10 = "wman4.jpeg"
    override func viewDidLoad() {
        super.viewDidLoad()
        if (FIRAuth.auth()?.currentUser) != nil {
            self.ref = FIRDatabase.database().referenceFromURL("https://abled-e36b6.firebaseio.com/")
            self.ref.child("users").child(FIRAuth.auth()!.currentUser!.uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                // check if user has photo
                print(snapshot.description)
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


    override func viewWillAppear(animated: Bool) {
        if let user = FIRAuth.auth()?.currentUser {
            let name = user.displayName
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
        let cell = tableView.dequeueReusableCellWithIdentifier("MessagesTableViewCell") as! MessagesTableViewCell
        let thumbils:[String] = [ pic1,pic2,pic3,pic4,pic5,pic6,pic7,pic8,pic9,pic10]
        cell.profilersImage?.image = UIImage(named: thumbils[indexPath.row])
        //cell.myUserName?.text = testArray[indexPath.item]
        cell.messageText?.text = commentArray[indexPath.item]
        cell.profilersName?.text = testArray[indexPath.item]
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
