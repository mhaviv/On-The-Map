//
//  StudentData.swift
//  On The Map
//
//  Created by Michael Haviv on 12/1/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

import Foundation

struct StudentData: Codable {
    
    var id: String
    var firstName: String
    var lastName: String
    var longitude: Double
    var latitude: Double
    var locationName: String
    var mediaURL: String
    var createdAt: String
    var updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "objectId"
        case firstName
        case lastName
        case longitude
        case latitude
        case locationName = "mapString"
        case mediaURL
        case createdAt
        case updatedAt
    }
}
