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
import Social

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
    var userArray: NSMutableArray!
    var mySelected: Posts!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.goToMessage(_:)), name:"refresh", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.addFollower(_:)), name:"refresh2", object: nil)
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
                    let storageRef = storage.referenceForURL("gs://abled-e36b6.appspot.com/defaultImage/No_Image_Available.png")
                    storageRef.dataWithMaxSize(20*1024*1024, completion: { (data, error) in
                        if(data != nil){
                        let userPhoto = UIImage(data: data!)
                        self.proPic.image = userPhoto
                        }
                    })
                    
                }
            })
        }
    }
    
    func goToMessage(notification: NSNotification){
        
        
        let myUser = Users()
        myUser.id = mySelected.Id
        myUser.name = mySelected.Name
        myUser.url = NSURL(fileURLWithPath:  mySelected.MyURL)
        let defaults = NSUserDefaults()
        defaults.setObject(myUser.id, forKey: "myUserID")
        defaults.setObject(myUser.name, forKey: "myUserName")
        defaults.synchronize()
        NSNotificationCenter.defaultCenter().postNotificationName("message", object: nil)
        //var secondTab = self.tabBarController?.viewControllers[1] as SecondViewController
        //secondTab.array = firstArray
        tabBarController?.selectedIndex = 2
    }
    
    func addFollower(notification: NSNotification){
        
        print("hit follow")

        let dict = ["UID": mySelected.Id, "Name": mySelected.userName, "URL": mySelected.MyURL]
        let id = FIRAuth.auth()?.currentUser?.uid
        let myString = "https://abled-e36b6.firebaseio.com//users//" + id! + "//followers"
        let followRef  = FIRDatabase.database().referenceFromURL(myString)
        followRef.child(mySelected.Id).updateChildValues(["myValues": dict])
        
    }

    func fireBaseFunc() {
        self.imageArray = [UIImage]()
        self.reviewedArray = [Posts]()
        self.ref = FIRDatabase.database().referenceFromURL("https://abled-e36b6.firebaseio.com//user-posts")
        self.ref.queryOrderedByChild("key").observeEventType(.Value, withBlock: { snapshot in
            if snapshot.exists(){
                for child in snapshot.children{
                    
                    for item in child.children{
                        let myName = item.value["name"] as! String
                        let myComment = item.value["placeComments"] as! String
                        let myAdd = item.value["address"] as! String
                        let type = item.value["type"] as! String
                        let urlString = item.value["image_path"] as! String
                        let rating = item.value["starCount"] as! Double
                        let myKey = item.value["key"] as! String
                        let userName = item.value["userName"] as! String
                        let myID = item.value["uid"] as! String
                        
                        let myPost = Posts(name: myName, address: myAdd, type: type, rating: rating, url: urlString, comment: myComment, key: myKey, user: userName, id: myID)
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
            //let photoUrl = user.photoURL
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
        if self.reviewedArray == nil {
            let myPost = Posts(name: "No Data",address: "No Data",type: "No Data",rating: 0,url: "No Data", comment: "No Data", key: "No Data", user: "No Data",id: "")
            self.reviewedArray = [myPost]
            return self.reviewedArray.count
        }else{
            return self.reviewedArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeTableViewCell") as! HomeTableViewCell
        if self.reviewedArray == nil {
            let myPost = Posts(name: "No Data",address: "No Data",type: "No Data",rating: 0,url: "No Data", comment: "No Data", key: "No Data", user: "No Data", id: "")
            self.reviewedArray = [myPost]
            cell.postersName.text = self.reviewedArray[indexPath.item].userName
            cell.postersName.adjustsFontSizeToFitWidth = true
            cell.myTextView.text = self.reviewedArray[indexPath.item].myComment
            cell.placeName.text = self.reviewedArray[indexPath.row].Name
            
            cell.myImageView?.image = self.imageArray[indexPath.item]
            
        }else{
            cell.postersName.text = self.reviewedArray[indexPath.item].userName
            cell.postersName.adjustsFontSizeToFitWidth = true
            cell.myTextView.text = self.reviewedArray[indexPath.item].myComment
            cell.placeName.text = self.reviewedArray[indexPath.row].Name
            cell.userRating.value = CGFloat(self.reviewedArray[indexPath.row].Rating)
            if (imageArray != nil) {
            cell.myImageView?.image = self.imageArray[indexPath.item]
                
                
            }
            
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeTableViewCell") as! HomeTableViewCell
        let row = indexPath.row
        print("Row: \(row)")
        let myObject = reviewedArray[row]
        mySelected = myObject
        
        cell.shareButton.tag = indexPath.row
        print(cell.shareButton.tag.description)
        cell.shareButton.addTarget(self, action: #selector(HomeViewController.postToFacebookTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        print(self.reviewedArray[row] )
        let popoverContent = (self.storyboard?.instantiateViewControllerWithIdentifier("Menu"))! as UIViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSizeMake(self.view.frame.width/3, self.view.frame.height/3)
        popover!.delegate = self
        popover!.sourceView = self.view
        popover!.sourceRect = CGRectMake(cell.frame.width/2, cell.frame.height/2,0,0)
        
        
        self.navigationController!.presentViewController(nav, animated: true, completion: nil)
        
        
        //let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("EnterData");
        //self.navigationController!.pushViewController(viewController, animated: true)
        
    }
    
    
    @IBAction func postToFacebookTapped(sender: UIButton) {
        if(SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook)) {
            let socialController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            let buttonRow = sender.tag
            let myText = ("I just reviewed " + self.reviewedArray[buttonRow].Name + " on the Abled App, join me and help the community")
            socialController.setInitialText(myText)
            
            
            self.presentViewController(socialController, animated: true, completion: nil)
        }
    }
    
    
}
