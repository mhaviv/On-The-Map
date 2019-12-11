//
//  StudentData.swift
//  On The Map
//
//  Created by Michael Haviv on 12/1/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

import Foundation

struct StudentData: Decodable {
    var id: String
    var firstName: String
    var lastName: String
    var longitude: Double
    var latitude: Double
    var mediaURL: String
    
    enum CodingKeys: String, CodingKey {
        case id = "objectId"
        case firstName
        case lastName
        case longitude
        case latitude
        case mediaURL
    }
}
