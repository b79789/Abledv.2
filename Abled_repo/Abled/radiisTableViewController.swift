//
//  radiisTableViewController.swift
//  Abled
//
//  Created by Brian Stacks on 7/27/16.
//  Copyright © 2016 Brian Stacks. All rights reserved.
//

import UIKit

class radiisTableViewController: UITableViewController {

    var array: [String] = ["5 Miles", "10 Miles", "25 Miles"]
    var appRadius: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.classForKeyedArchiver(), forCellReuseIdentifier: "cell")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 0){
            fiveMile()
            self.dismissViewControllerAnimated(true, completion: nil)
        }else if (indexPath.row == 1){
            tenMile()
            self.dismissViewControllerAnimated(true, completion: nil)
        }else if (indexPath.row == 2){
            twentfiveMile()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        cell!.textLabel?.text = array[indexPath.row]
        return cell!
    }
 
    func fiveMile(){
        appRadius = 8046
        NSUserDefaults.standardUserDefaults().setObject(appRadius, forKey: "radius")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func tenMile(){
        appRadius = 16093
        NSUserDefaults.standardUserDefaults().setObject(appRadius, forKey: "radius")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func twentfiveMile(){
        appRadius = 40233
        NSUserDefaults.standardUserDefaults().setObject(appRadius, forKey: "radius")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
