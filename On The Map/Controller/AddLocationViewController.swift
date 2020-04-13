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
    
    
        
//    let studentData = StudentData(id: userData, firstName: <#T##String#>, lastName: <#T##String#>, longitude: <#T##Double#>, latitude: <#T##Double#>, locationName: <#T##String#>, mediaURL: <#T##String#>, createdAt: <#T##String#>, updatedAt: <#T##String#>)
//
    // Decide whether we are performing a POST or a PUT request based on locationID
    var locationID: String?
    lazy var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Take in location string
        // ?Split string into address, city, state and country?
    // pass location string to geocoder
    
    
    
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
        
        self.processGeocodeResponse(location: location)
    }
    
    private func processGeocodeResponse(location: String) {
       enableViews(false)
       geocoder.geocodeAddressString(location) { (placemarkers, error) in
           
        self.enableViews(true)
           if let error = error {
               self.displayAlert(title: "Error", message: "Unable to Forward Geocode Address: (\(error))")
           } else {
               var location: CLLocation?
               
               if let placemarks = placemarkers, placemarks.count > 0 {
                   location = placemarks.first?.location
               }
               
            if let location = location {
                // get login first name, last name, get loca
                print(location)
//                let data =
//                ParseClient.sharedInstance().postLocations(studentData: data) { (successResponse) in
//                    self.syncStudentLocationToMap(location.coordinate)
//                }
                
            } else {
                self.displayAlert(title: "Error", message: "No Matching Location Found")
            }
           }
       }
    }
    
    private func performSegueToMap() {
        if let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeTab") as? TabBarViewController {
            UIApplication.shared.keyWindow?.rootViewController = tabBarController
            UIApplication.shared.keyWindow?.makeKeyAndVisible()
        }
    }
    
    private func syncStudentLocationToMap(_ coordinate: CLLocationCoordinate2D) {
        self.performSegueToMap()
        
        
    }
    
    func displayAlert(title: String, message: String?) {
        DispatchQueue.main.async {
            if let message = message {
                let alert = UIAlertController(title: title, message: "\(message)", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    /// Enables or disables the views to display the loading state.
    private func enableViews(_ isEnabled: Bool) {
        if isEnabled == true {
            DispatchQueue.main.async {
                Spinner.stop()
            }
        } else {
            DispatchQueue.main.async {
                Spinner.start()
            }
        }
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
