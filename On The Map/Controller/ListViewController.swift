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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
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
//                print("this is mapped students \(self.students)")
                print("locations retrieved")

                
//                self.displayStudents()
            
          }
        }
    
//    func displayStudents() {
//        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! ListCell
//            let studentObject = students[indexPath.row]
//
//            cell.cellImageView.contentMode = .scaleAspectFit
//            cell.nameLabel.text = studentObject.firstname + " " + studentObject.lastName
//            cell.urlLabel.text = studentObject.mediaUrl
//            return cell
//        }
//
//        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//            return true
//        }
//
//        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            students.count == 0 ? showEmptyView(true) : showEmptyView(false)
//            return students.count
//        }
//    }
    
    func showEmptyView(_ show: Bool) {
        if show {
            let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height))
            label.numberOfLines = 2
            label.textAlignment = .center
            label.text = "No Locations Stored!\nClick '+' to add a location"
            tableView.separatorStyle = .none
            tableView.backgroundView = label
            navigationItem.leftBarButtonItem = nil
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
            navigationItem.leftBarButtonItem = editButtonItem
        }
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        TabBarViewController.sharedInstance().logout()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! ListCell
        let studentObject = students[indexPath.row]
        cell.nameLabel.text = studentObject.firstname + " " + studentObject.lastName
        cell.urlLabel.text = studentObject.mediaUrl
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        students.count == 0 ? showEmptyView(true) : showEmptyView(false)
        return students.count
    }
    
//    override func tableView(_ tableView: UITableView, willDisplayCell cell: ListCell, cellForRowAt indexPath: IndexPath) {
//
//        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
//
//            cell.separatorInset = UIEdgeInsets.zero
//        }
//        if cell.responds(to: #selector(setter: UITableViewCell.preservesSuperviewLayoutMargins)) {
//
//            cell.preservesSuperviewLayoutMargins = false
//        }
//        if cell.responds(to: #selector(setter: UITableViewCell.layoutMargins)) {
//
//            cell.layoutMargins = UIEdgeInsets.zero
//        }
//    }
}
