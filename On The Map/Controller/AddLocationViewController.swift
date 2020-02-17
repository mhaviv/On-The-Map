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

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mediaURLTextfield: UITextField!
    
    // Decide whether we are performing a POST or a PUT request based on locationID
    var locationID: String?
    lazy var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func findLocation(_ sender: Any) {
        
        let location = locationTextField.text!
        let mediaURL = mediaURLTextfield.text!
        
        if location.isEmpty || mediaURL.isEmpty {
            displayAlert(withMessage: "All fields are required.")
            return
        }
        
        guard let url = URL(string: mediaURL), UIApplication.shared.canOpenURL(url) else {
            displayAlert(withMessage: "Please provide a valid link.")
            return
        }
    }
    
    private func geocode(location: String) {
       enableViews(false)
       geocoder.geocodeAddressString(location) { (placemarkers, error) in
           
        self.enableViews(true)
           if let error = error {
               self.displayAlert(withTitle: "Error", withMessage: "Unable to Forward Geocode Address (\(error))")
           } else {
               var location: CLLocation?
               
               if let placemarks = placemarkers, placemarks.count > 0 {
                   location = placemarks.first?.location
               }
               
               if let location = location {
                   self.syncStudentLocation(location.coordinate)
               } else {
                   self.displayAlert(withMessage: "No Matching Location Found")
               }
           }
       }
    }
    
    private func syncStudentLocation(_ coordinate: CLLocationCoordinate2D) {
        
        if let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeTab") as? TabBarViewController {
            UIApplication.shared.keyWindow?.rootViewController = tabBarController
            UIApplication.shared.keyWindow?.makeKeyAndVisible()
        }
        
    }
    

    func displayAlert(withTitle: String = "Info", withMessage: String, action: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: withTitle, message: withMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {(alertAction) in
                action?()
            }))
            self.present(alertController, animated: true)
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
}
