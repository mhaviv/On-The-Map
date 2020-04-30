//
//  MapViewController.swift
//  On The Map
//
//  Created by Michael Haviv on 11/9/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import GoogleSignIn

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locations: [StudentAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        setInitialMapLocation()
        self.enableViews(false)
        getUserData()
    }
    
    // MARK: - Actions
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        refreshAnnotations()
    }
    
    
    @IBAction func logoutPressed(_ sender: Any) {
        // identify the data you need for logout, modify the logout function to take that data and call API function from logout.
        TabBarViewController.sharedInstance().logout()
        GIDSignIn.sharedInstance().signOut()
    }
    
    // MARK: - Helpers
    
    func setInitialMapLocation() {
        let regionRadius: CLLocationDistance = 200000
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                      latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        // set initial location in NYC
        let initialLocation = CLLocation(latitude: 40.7829, longitude: -73.9654)
        centerMapOnLocation(location: initialLocation)
    }
    
    func refreshAnnotations() {
        self.enableViews(false)
        for annotation in mapView.annotations{
            mapView.removeAnnotation(annotation)
        }
        //getUserData()
        displayLocations()
    }
    
    
    func getUserData() {
        ParseClient.sharedInstance().getLocations { [weak self] (results) in
            guard let studentInfo = results else {
                print("No Results from Parse API")
                return
            }
            
            // Maps student data and filters nil values with compactMap
            let mappedLocations = studentInfo.compactMap() { (user) -> (StudentAnnotation) in
                return StudentAnnotation(with: CLLocationCoordinate2D(latitude: user.latitude, longitude: user.longitude), locationName: user.locationName, mediaURL: user.mediaURL)
                
            }
            
            self?.locations = mappedLocations
            print("locations data retrieved for MapView")
            
            if self?.mapView.annotations.count == 0 {
                self?.displayLocations()
            }
        }
    }
    
    func updateUserData() {
//        ParseClient.sharedInstance().updateLocations(completion: <#T##(([StudentData]?) -> ())?##(([StudentData]?) -> ())?##([StudentData]?) -> ()#>)
    }
    
    func displayLocations() {
        self.mapView.addAnnotations(self.locations)
        
        if mapView.annotations.count > 0 {
            print("locations rendered to map")
            self.enableViews(true)
        }
    }
    
    /// Enables or disables the views to display the loading state.
    private func enableViews(_ isEnabled: Bool) {
        if isEnabled == true {
            Spinner.stop()
        } else {
            Spinner.start()
        }
    }
    
    
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
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
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            
            if let studentAnnotation = (view.annotation as? StudentAnnotation), let mediaURL = URL(string: studentAnnotation.mediaURL) {
                app.open(mediaURL, options: [:], completionHandler: nil)
            }
        }
    }
    
}
