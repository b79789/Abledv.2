//
//  PlacesReviewedController.swift
//  Abled
//
//  Created by Brian Stacks on 1/15/16.
//  Copyright © 2016 Brian Stacks. All rights reserved.
//

import UIKit
import Firebase


class PlacesReviewController: UIViewController, UITableViewDelegate, UITableViewDataSource
 {
    @IBOutlet weak var proPic: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    let placeArray = ["Porky's", "Jacks", "Jim's","Mary's", "Goodyear", "First turn","Bella's", "Dairy Center", "Recreation Dept.","Toby's"]
    let addressArray = ["123 Testing Dr. Charlotte NC", "123 Testing Dr. Charlotte NC", "123 Testing Dr. Charlotte NC","123 Testing Dr. Charlotte NC", "123 Testing Dr. Charlotte NC", "123 Testing Dr. Charlotte NC","123 Testing Dr. Charlotte NC", "123 Testing Dr. Charlotte NC", "123 Testing Dr. Charlotte NC","123 Testing Dr. Charlotte NC"]
    let pic1 =  "barCafe.jpg"
    let pic2 = "bjs.png"
    let pic3 = "jackinthebox_restaurant_thumb.png"
    let pic4 = "humpty.png"
    let pic5 = "fan_fang_thumb.png"
    let pic6 = "aw.gif"
    let pic7 =  "brand.gif"
    let pic8 =  "Chi-Chi.gif"
    let pic9 =  "jacks.jpg"
    let pic10 = "tobys_bar_restaurant_87028.jpg"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "customcell")
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

   
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return placeArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PlacesReviewed") as! MyReviewedTableViewCell
        
        let thumbils:[String] = [ pic1,pic2,pic3,pic4,pic5,pic6,pic7,pic8,pic9,pic10]
        cell.nameLabel.text = placeArray[indexPath.item]
        cell.nameLabel.adjustsFontSizeToFitWidth = true
        cell.cellImage.image = UIImage(named: thumbils[indexPath.row])
        
        cell.addressLabel.text = addressArray[indexPath.item]
        cell.addressLabel.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        print("Row: \(row)")
        
        print(placeArray[row] )
       
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("EnterData");
            self.navigationController!.pushViewController(viewController, animated: true)
        
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
