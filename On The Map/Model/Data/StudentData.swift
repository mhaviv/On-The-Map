//
//  StudentData.swift
//  On The Map
//
//  Created by Michael Haviv on 12/1/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

import Foundation

struct StudentData: Codable {
    
    let objectId: String?
    let accountKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Double?
    let longitude: Double?
    let createdAt: Date?
    let updatedAt: Date?
    
    
    
}
