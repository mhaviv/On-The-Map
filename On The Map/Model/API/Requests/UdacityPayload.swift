//
//  Payload.swift
//  On The Map
//
//  Created by Michael Haviv on 12/11/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

import Foundation

// Payload sent to Udacity API to retrieve Session Response
struct UdacityPayload: Codable {
    var payload: UserPayload
    
    enum CodingKeys: String, CodingKey {
        case payload = "udacity"
    }
}
