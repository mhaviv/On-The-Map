//
//  UserData.swift
//  On The Map
//
//  Created by Michael Haviv on 12/8/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

import Foundation

// Should be struct when getting data
struct UserData: Codable {
    
    let firstName: String?
    let lastName: String?
    let key: String?
}
