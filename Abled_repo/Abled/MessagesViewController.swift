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
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    var messages: [FIRDataSnapshot]! = []
    var msglength: NSNumber = 10
    private var _refHandle: FIRDatabaseHandle!
    var storageRef: FIRStorageReference!
    @IBOutlet weak var clientTable: UITableView!
    var mySentUser: Users!
    var userArray = [Users]()
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MessagesViewController.gotToSingleMessage(_:)), name:"message", object: nil)
        if (FIRAuth.auth()?.currentUser) != nil {
            fireBaseFunc()
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


    func gotToSingleMessage(notification: NSNotification){

        print("gotToSingleMessage")
    
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let returnValue = NSUserDefaults.standardUserDefaults().objectForKey("myUserID") as? String
        print(returnValue)
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
    
    
    
    func fireBaseFunc() {
        let id = (FIRAuth.auth()?.currentUser?.uid)! as String
        self.ref = FIRDatabase.database().referenceFromURL("https://abled-e36b6.firebaseio.com/users/")
        self.ref.queryOrderedByValue().observeEventType(.Value, withBlock: { snapshot in
            
            if snapshot.exists(){
                
                for snap in snapshot.children{
                    print(snap.description)
                        let name = snap.value["userName"] as? String
                        let id = snap.value["userID"] as? String
                        let url = snap.value["userPhoto"] as? String
                        let users = Users()
                        users.name = name!
                        users.id = id!
                        users.url = NSURL(string: url!)!
                        self.userArray.append(users)
                        self.clientTable.reloadData()
                        
                        
                    
                    
                }
            }
            
            
        })
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MessagesTableViewCell") as! MessagesTableViewCell
        cell.messageText?.text = userArray[indexPath.item].id
        cell.profilersName?.text = userArray[indexPath.item].name
        let url =  userArray[indexPath.row].url
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let data = NSData(contentsOfURL: url) //make sure your image in this url does exist, otherwise unwrap in a if let check
            dispatch_async(dispatch_get_main_queue(), {
                cell.profilersImage.image = UIImage(data: data!)
            });
        }
        //cell.myUserName?.text = testArray[indexPath.item]
        
        //cell.myUserName?.text = testArray[indexPath.item]
        //cell.textLabel?.text = testArray[indexPath.item]
        //cell.imageView?.image = UIImage(named: thumbils[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        print("Row: \(row)")
        
        print(userArray[row] )
        
        //let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("EnterData");
        //self.navigationController!.pushViewController(viewController, animated: true)
        
    }
    
    
}
