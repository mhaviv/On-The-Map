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
    
//    init?(userData: [String: AnyObject]) {
//        guard let firstName = userData[UdacityClient.JSONResponseKeys.firstName] as? String,
//            let lastName = userData[UdacityClient.JSONResponseKeys.lastName] as? String
//        else {
//            return nil
//        }
//        
//        self.firstName = firstName
//        self.lastName = lastName
//        
//        guard let key = userData[UdacityClient.JSONResponseKeys.userKey] as? String else {
//            return nil
//        }
//        
//        self.key = key
//    }
}
