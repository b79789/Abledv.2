//
//  LocalViewController.swift
//  Abled
//
//  Created by Brian Stacks on 1/15/16.
//  Copyright © 2016 Brian Stacks. All rights reserved.
//


import Foundation
import UIKit
import Firebase
import MapKit

class LocalViewController: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var proPic: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
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
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
       
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "customcell1")
        
    }
    
    func mapView(mapView: MKMapView,
                 viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            //pinView!.animatesDrop = true
            pinView!.image = UIImage(named:"map_icon.png")!
            
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04))
        
        self.mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = "Here"
        annotation.subtitle = "You Are"
        mapView.addAnnotation(annotation)
        let newtonLocation = CLLocationCoordinate2DMake(35.639441, -81.238403)
        // Drop a pin
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = newtonLocation
        dropPin.title = "Porky's"
        let newtonLocation2 = CLLocationCoordinate2DMake(35.687139, -81.220207)
        // Drop a pin
        let dropPin2 = MKPointAnnotation()
        dropPin2.coordinate = newtonLocation2
        dropPin2.title = "Jacks"
        let newtonLocation3 = CLLocationCoordinate2DMake(35.665943, -81.221581)
        // Drop a pin
        let dropPin3 = MKPointAnnotation()
        dropPin3.coordinate = newtonLocation3
        dropPin3.title = "Jim's"
        mapView.addAnnotations([dropPin,dropPin2,dropPin3])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return placeArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let thumbils:[String] = [ pic1,pic2,pic3,pic4,pic5,pic6,pic7,pic8,pic9,pic10]
       
        let cell = tableView.dequeueReusableCellWithIdentifier("LocalTableViewCell") as! LocalTableViewCell
        // Load images
        //let cell = tableView.dequeueReusableCellWithIdentifier("customcell1", forIndexPath: indexPath) as UITableViewCell
        cell.nameLabel.text = placeArray[indexPath.item]
        
        cell.cellImage.image = UIImage(named: thumbils[indexPath.row])
        cell.addressLabel.text = addressArray [indexPath.item]
        cell.addressLabel.adjustsFontSizeToFitWidth = true
       
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        print("Row: \(row)")
        
        print(placeArray[row] )
        
        
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AddPlace");
        self.navigationController!.pushViewController(viewController, animated: true)
        
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
}