//
//  Places.swift
//  Abled
//
//  Created by Brian Stacks on 8/2/16.
//  Copyright © 2016 Brian Stacks. All rights reserved.
//

import UIKit

class Places {
    //var Id: Int
    var Name: String
    var Address: String
    var Type: String
    var Rating: Double
    var Icon: NSData
    var Lat: Double
    var Lon: Double
    
    init( name: String?, address: String?, type: String?, rating: Double?, icon: NSData, lat: Double, lon: Double) {
        //self.Id = id
        self.Name = name!
        self.Address = address!
        self.Type = type!
        self.Rating = rating!
        self.Icon = icon
        self.Lat = lat
        self.Lon = lon
    }
    

}
