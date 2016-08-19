//
//  MapLocations.swift
//  Abled
//
//  Created by Brian Stacks on 8/3/16.
//  Copyright © 2016 Brian Stacks. All rights reserved.
//

import Foundation
import MapKit

class MapLocations: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        
        super.init()
    }
}