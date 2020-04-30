//
//  TableViewController.swift
//  On The Map
//
//  Created by Michael Haviv on 11/9/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn

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
        refreshTableView()
    }
    
    // MARK: - Actions
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        refreshTableView()
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        TabBarViewController.sharedInstance().logout()
        GIDSignIn.sharedInstance().signOut()
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
        if students.count == 0 {
            enableViews(false)
            showEmptyView(true)
        } else {
            showEmptyView(false)
            enableViews(true)
        }
        return students.count
    }
    
    // MARK: - Helpers
    
    func refreshTableView() {
//        getUserData()
        self.enableViews(false)
        self.tableView.reloadData()
    }
    
    func getUserData() {
        ParseClient().getLocations { [weak self] (results) in
            guard let studentInfo = results else {
                print("No Results from Parse API")
                self?.showEmptyView(true)
                
                return
            }
            
            // Maps student data and filters nil values with compactMap
            let mappedStudents = studentInfo.compactMap() { (user) -> (StudentTableViewObject) in
                
                return StudentTableViewObject(firstname: user.firstName, lastName: user.lastName, locationName: user.locationName, mediaUrl: user.mediaURL)
                
            }
            
            self?.students = mappedStudents
            print("location data retrieved for ListView")
            
        }
    }
    
    
    func showEmptyView(_ show: Bool) {
        if show{
            let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableView.frame.height))
            label.numberOfLines = 2
            label.textAlignment = .center
            label.text = "No Locations Stored!\nClick '+' to add a location"
            self.tableView.separatorStyle = .none
            self.tableView.backgroundView = label
            self.navigationItem.leftBarButtonItem = nil
            enableViews(true)
        } else {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .singleLine
            self.navigationItem.leftBarButtonItem = self.editButtonItem
            enableViews(true)
            print("locations rendered to ListView")
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
