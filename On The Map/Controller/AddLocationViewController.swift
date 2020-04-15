//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by Michael Haviv on 12/9/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mediaURLTextfield: UITextField!
    
    
    
    // Decide whether we are performing a POST or a PUT request based on locationID
    var locationID: String? // Is this needed?
    lazy var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        #if DEBUG
        locationTextField.text = "1275 E 68th st Brooklyn, NY 11234"
        mediaURLTextfield.text = "https://www.google.com"
        #endif
    }
    
    /* Take in location string
     Split string into address, city, state and country?
     pass location string to geocoder */
    @IBAction func geocode(_ sender: Any) {
        
        let location = locationTextField.text ?? ""
        let mediaURL = mediaURLTextfield.text ?? ""
        
        if location.isEmpty || mediaURL.isEmpty {
            displayAlert(title: "Error", message: "All fields are required")
            return
        }
        
        guard let url = URL(string: mediaURL), UIApplication.shared.canOpenURL(url) else {
            displayAlert(title: "Error", message: "Please provide a valid link")
            return
        }
        
        processGeocodeResponse(location: location, mediaURL: mediaURL)
    }
    
    private func processGeocodeResponse(location locationString: String, mediaURL: String) {
        enableViews(false)
        geocoder.geocodeAddressString(locationString) { [weak self] (placemarkers, error) in
            
            self?.enableViews(true)
            if let error = error {
                self?.displayAlert(title: "Error", message: "Unable to Forward Geocode Address: (\(error))")
            } else {
                var location: CLLocation?
                
                if let placemarks = placemarkers, placemarks.count > 0 {
                    location = placemarks.first?.location
                }
                
                if let location = location,
                    let request = AddStudentRequest(location: (location, locationString), mediaURL: mediaURL, userData: UserData(firstName: "Joe", lastName: "Doe", key: "1234")) {
                    // get login first name, last name, get loca
                    print(location)
                    self?.postLocations(request, location: location)
                    
                } else {
                    self?.displayAlert(title: "Error", message: "No Matching Location Found")
                }
            }
        }
    }
    
    private func postLocations(_ request: AddStudentRequest, location: CLLocation) {
        ParseClient.sharedInstance().postLocations(request: request) { [weak self] (successResponse) in
            self?.syncStudentLocationToMap(location.coordinate)
        }
    }
    
    private func performSegueToMap() {
        if let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeTab") as? TabBarViewController {
            UIApplication.shared.windows.first?.rootViewController = tabBarController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
    
    private func syncStudentLocationToMap(_ coordinate: CLLocationCoordinate2D) {
        self.performSegueToMap()
    }
    
    func displayAlert(title: String, message: String?) {
        if let message = message {
            let alert = UIAlertController(title: title, message: "\(message)", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /// Enables or disables the views to display the loading state.
    private func enableViews(_ isEnabled: Bool) {
        isEnabled ? Spinner.stop() : Spinner.start()
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

extension AddStudentRequest {
    init?(location: (CLLocation, name: String), mediaURL: String, userData: UserData) {
        guard
            let firstName = userData.firstName,
            let lastName = userData.lastName,
            let id = userData.key
            else {
                return nil
        }
        self.init(uniqueKey: id, firstName: firstName, lastName: lastName, mapString: location.name, mediaURL: mediaURL, latitude: location.0.coordinate.latitude, longitude: location.0.coordinate.longitude)
    }
}
