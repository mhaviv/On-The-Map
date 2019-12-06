//
//  TabBarVCHelper.swift
//  On The Map
//
//  Created by Michael Haviv on 12/6/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

import Foundation
import UIKit

extension TabBarViewController {
    
    func displayAlert(title: String, message: String?) {
        if let message = message {
            let alert = UIAlertController(title: title, message: "\(message)", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
        func logout() {
            UdacityClient.sharedInstance().LogoutUser { (session, error) in
                if error == nil {
                    DispatchQueue.main.async {
                        if let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                            UIApplication.shared.keyWindow?.rootViewController = loginViewController
                            UIApplication.shared.keyWindow?.makeKeyAndVisible()
                        }
                    }
                    
                } else if error != nil {
                    DispatchQueue.main.async {
                        self.displayAlert(title: "Logout Unsuccessful", message: "\(error!.localizedDescription)")
                        
                        return
                    }
                } else {
                    DispatchQueue.main.async {
                        self.displayAlert(title: "Logout Unsuccessful", message: "Logout Failed")
                        
                        return
                    }
                }
                //have generic alert method which takes message and actions
                DispatchQueue.main.async {
                    self.displayAlert(title: "Logout Successful", message: "You have logged out successfully")
                }
            }
        }
    }
