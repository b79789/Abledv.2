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
import GooglePlaces
import FirebaseStorage

class LocalViewController: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate {
    
    var placeName = String()
    var placeAddress = String()
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var proPic: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    @IBOutlet weak var myTableView: UITableView!
    var locale: CLLocationCoordinate2D!
    var myLocalPlaces = [Places]()
    var idArray = [String]()
    var myUrl: String!
    var placesArray:[Places!] = []
    var imgData:NSData!
    var placeIcon: NSData!
    var placeLat: Double!
    var placeLon: Double!
    var ref:FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationPosition()
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "customcell1")
        
    
        if let user = FIRAuth.auth()?.currentUser {
            self.ref = FIRDatabase.database().referenceFromURL("https://stacksapp-7b63c.firebaseio.com/")
            self.ref.child("users").child(FIRAuth.auth()!.currentUser!.uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                // check if user has photo
                print(snapshot.description)
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
    
    override func viewWillAppear(animated: Bool) {
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways){
            let currentLocation = self.locationManager.location
            let longitude = currentLocation!.coordinate.longitude
            let latitude = currentLocation!.coordinate.latitude
            locale = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
            fetchPlacesNearCoordinate(locale, radius: 2000, types: [""])
            
        }
        
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
            
            myTableView.reloadData()
        } else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(viewController, animated: true, completion: nil)
            })
            print("No user signed in")
        }
    }
    
    func locationPosition(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
  
    
    func fetchPlacesNearCoordinate(coordinate: CLLocationCoordinate2D, radius: Double, types:[String]) {
        var urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=\("AIzaSyBPJj0Q7wW1ofFZ3icRSPwau6qda4yA7Pw")&location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(radius)&rankBy=distance&sensor=true"
        let typesString = types.count > 0 ? types.joinWithSeparator("|") : "food"
        urlString += "&types=\(typesString)"
        urlString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let session = NSURLSession.sharedSession()
        let placesTask = session.dataTaskWithURL(NSURL(string: urlString)!) {data, response, error in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if let jsonResult = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))) as? NSDictionary {
                let returnedPlaces: NSArray? = jsonResult["results"] as? [[String:AnyObject]]
                if returnedPlaces != nil {
                    for result in returnedPlaces! {
                        self.placeName = (result["name"] as! String?)!
                            if let myId = result["place_id"] as? NSString {
                                let iden = myId as String
                                self.myUrl = "https://maps.googleapis.com/maps/api/place/details/json?placeid=" + iden + "&key=AIzaSyBPJj0Q7wW1ofFZ3icRSPwau6qda4yA7Pw"
                                if let url = NSURL(string: self.myUrl) {
                                    self.getData(url)
                            }
                        }
                    }
                }
            }
        }
        placesTask.resume()
    }
    
    func getData (url: NSURL){
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        let myTask = session.dataTaskWithRequest(request) { (data: NSData?, url: NSURLResponse?,error: NSError?) in
            if error == nil {
                    do {
                        let jsonDict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                        if let results = jsonDict!["result"]{
                            //let place = Places()
                            var myplaceName = ""
                            var placeAddress = ""
                            let placeType = ""
                            var placeRating = 0.0
                            
                            if let address = results.objectForKey("formatted_address") {
                            placeAddress = address as! String
                            } else {
                                let error = "Error"
                                print(error)
                            }
                            if let name = results.objectForKey("name") {
                                myplaceName = name as! String
                            } else {
                                myplaceName = "Error"
                            }
                            if let rating:Double = results.objectForKey("rating") as? Double {
                                
                                placeRating = rating
                            } else {
                                //let error = "No Rating Available"
                                //print(error)
                            }
                            if let myPhoto = results.objectForKey("icon"){
                                let url = NSURL(string: myPhoto as! String)
                                let data = NSData(contentsOfURL: url!)
                                self.placeIcon = data!
                                self.loadMyImage(myPhoto as! String)
                            }
                            if let myGeo = results.objectForKey("geometry")?.objectForKey("location"){
                                let lat = myGeo.objectForKey("lat")
                                let lng = myGeo.objectForKey("lng")
                                self.placeLat = ((lat)?.doubleValue)!
                                self.placeLon = ((lng)?.doubleValue)!

                            } else {
                                
                            }
//                            if let type = results.objectForKey("types") {
//                                
//                                placeType = type as! String
//                            } else {
//                                
//                            
//                            }
                            let place = Places(name: myplaceName, address: placeAddress, type: placeType, rating: placeRating, icon: self.placeIcon, lat: self.placeLat, lon: self.placeLon)
                            self.placesArray.append(place)
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.myTableView.reloadData()
                            })
                        }
                    }catch let error as NSError {
                        
                        print(error)
                }
               
                
            }
        }
        myTask.resume()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //let thumbils:[String] = [ pic1,pic2,pic3,pic4,pic5,pic6,pic7,pic8,pic9,pic10]
        let thePlaces = placesArray[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("LocalTableViewCell") as! LocalTableViewCell
        cell.nameLabel.text = thePlaces.Name
        cell.cellImage.image = UIImage(data:thePlaces.Icon,scale:1.0)
        cell.addressLabel.text = thePlaces.Address
        cell.addressLabel.adjustsFontSizeToFitWidth = true
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
       // let row = indexPath.row
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AddPlace");
        self.navigationController!.pushViewController(viewController, animated: true)
        
    }
    
  
    func mapView(mapView: MKMapView,
                 viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView?.pinTintColor = UIColor.orangeColor()
            pinView!.animatesDrop = true
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let location = locations.last! as CLLocation
        locale = location.coordinate
        
        
        //print(locale)
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
        self.mapView.setRegion(region, animated: true)
        for place in placesArray{

            let annotation2 = MapLocations(title: place.Name, subtitle: place.Address, coordinate: CLLocationCoordinate2D(latitude: place.Lat, longitude:  place.Lon))
            mapView.addAnnotation(annotation2)
        }
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = "Here"
        annotation.subtitle = "You Are"
        mapView.addAnnotation(annotation)
    }
    
    func loadMyImage(urlString: String!) {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let imgUrl:NSURL = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: imgUrl)
        request.HTTPMethod = "GET"
        let task = session.dataTaskWithRequest(request) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            if (error == nil) {
                // Success
                self.imgData = data
                
   
            }
            else {
                // Failure
                print("Error: %@", error!.localizedDescription);
            }
            
            
        }
        task.resume()
    }
}