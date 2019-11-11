//
//  MapLocation.swift
//  On The Map
//
//  Created by Michael Haviv on 11/9/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

import Foundation
import MapKit

class MapLocation: NSObject, MKAnnotation {
    
    let locationName: String
    var coordinate: CLLocationCoordinate2D
    let website: String
    
    init(locationName: String, coordinate: CLLocationCoordinate2D, website: String) {
        
        self.locationName = locationName
        self.coordinate = coordinate
        self.website = website
        
        super.init()
    }
    
    var title: String? {
      return locationName
    }
        
}
