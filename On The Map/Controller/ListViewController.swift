//
//  TableViewController.swift
//  On The Map
//
//  Created by Michael Haviv on 11/9/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UITableViewController {
    
    var students: [StudentTableViewObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        
        getUserData()
    }
    
    func getUserData() {
            ParseClient().getLocations { (results) in
              guard let studentInfo = results else {
                  print("No Results from Parse API")
                
                  return
              }
                
                // Maps student data and filters nil values with compactMap
                let mappedStudents = studentInfo.compactMap() { (user) -> (StudentTableViewObject) in
                
                    return StudentTableViewObject(firstname: user.firstName, lastName: user.lastName, locationName: user.locationName, mediaUrl: user.mediaURL)
            
                }
                            
                self.students = mappedStudents
                
                self.displayStudents()
            
          }
        }
    
    func displayStudents() {
        
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        TabBarViewController.sharedInstance().logout()
    }
    
}
