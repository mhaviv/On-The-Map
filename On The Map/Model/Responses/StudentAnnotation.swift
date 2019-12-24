//
//  MapLocation.swift
//  On The Map
//
//  Created by Michael Haviv on 11/9/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

import Foundation
import MapKit

class StudentAnnotation: NSObject, MKAnnotation {
    
    var locationName: String
//    var locationDEK: String
    var coordinate: CLLocationCoordinate2D
    var mediaURL: String
    
    init(with coordinate: CLLocationCoordinate2D, locationName: String, mediaURL: String) {
        
        self.coordinate = coordinate
        self.locationName = locationName
//        self.locationDEK = locationDEK
        self.mediaURL = mediaURL
        
        super.init()
    }
    
    var title: String? {
      return locationName
    }
    
//    var subtitle: String? {
//        return locationDEK
//    }
    
    
    // function that takes in json locationName and then forward geocodes to coordinates
        
}
