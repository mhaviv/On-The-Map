//
//  MapViewController.swift
//  On The Map
//
//  Created by Michael Haviv on 11/9/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

import Foundation
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set initial location in NYC
        let initialLocation = CLLocation(latitude: 40.7829, longitude: -73.9654)
        centerMapOnLocation(location: initialLocation)
        
        mapView.delegate = self
        
        // Annotation Example
        let mapPin = MapLocation(locationName: "Loeb Boathouse Restaurant",
                                 coordinate: CLLocationCoordinate2D(latitude: 40.7752771, longitude: -73.9687257),
                                 website: "http://www.thecentralparkboathouse.com")
        // Add Annotation
        mapView.addAnnotation(mapPin)
        
    }
    
    let regionRadius: CLLocationDistance = 10000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
      mapView.setRegion(coordinateRegion, animated: true)
    }
}

// Present visual indicator when tapping map pin
extension MapViewController: MKMapViewDelegate {
    
    // Gets called for every annotation you add to the map
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // Verify it only displays annotations for user location
//        guard let annotation = annotation as? Location else { return nil }
        
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        
        // Check to see if a reusable annotation view is available
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // Create a new MKMarkerAnnotationView object
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y:5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}
