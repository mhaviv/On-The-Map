//
//  Payload.swift
//  On The Map
//
//  Created by Michael Haviv on 12/11/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

import Foundation

struct Payload: Codable {
    var payload: UserPayload
    
    enum CodingKeys: String, CodingKey {
        case payload = "udacity"
    }
}
