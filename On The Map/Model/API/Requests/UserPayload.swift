//
//  UserPayload.swift
//  On The Map
//
//  Created by Michael Haviv on 12/11/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

import Foundation

// Payload sent to UdacityPayload to help retrieve Session Response
struct UserPayload: Codable {
    var username: String
    var password: String
}
