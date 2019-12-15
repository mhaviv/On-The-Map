//
//  ParseAPIResponse.swift
//  On The Map
//
//  Created by Michael Haviv on 12/11/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

import Foundation

// Response from Parse API
struct ParseResponse<T: Decodable>: Decodable {
    var results:[T]
    
    enum CodingKeys: String, CodingKey {
        case results
    }

}
