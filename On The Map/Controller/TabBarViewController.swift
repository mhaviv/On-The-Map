//
//  TabBarViewController.swift
//  On The Map
//
//  Created by Michael Haviv on 12/5/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController {
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
//        userLoginCheck(loggedIn: false)
    }
    
    func userLoginCheck(let loggedIn: Bool) {
    
        if loggedIn == true {
            print("User is logged in!")
            return
        } else {
            print("User needs to sign in")
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
            self.present(controller, animated: false, completion: nil)
        }

    }
}
