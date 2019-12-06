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
                
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    class func sharedInstance() -> TabBarViewController {
        struct Singleton {
            static var sharedInstance = TabBarViewController()
        }
        return Singleton.sharedInstance
    }
}
