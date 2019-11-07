//
//  ViewController.swift
//  On The Map
//
//  Created by Michael Haviv on 11/5/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set initial location in NYC
        let initialLocation = CLLocation(latitude: 40.7829, longitude: -73.9654)
        centerMapOnLocation(location: initialLocation)
//        mapView.delegate = self
    }
    
    let regionRadius: CLLocationDistance = 10000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
      mapView.setRegion(coordinateRegion, animated: true)
    }


}

