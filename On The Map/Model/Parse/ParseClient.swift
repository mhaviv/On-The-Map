//
//  ParseClient.swift
//  On The Map
//
//  Created by Michael Haviv on 12/8/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

import Foundation

struct ParseClient {
    
    struct Endpoints {
        static let studentLocation = "https://onthemap-api.udacity.com/v1/StudentLocation?"
    }
    
    struct parameterKeys {
        static let limit = "limit"
        static let skip = "skip"
        static let updatedAt = "updatedAt"
        static let order = "order=-"
        static let uniqueKey = "uniqueKey"
        static let uniqueKeyString = "uniqueKey=\(uniqueKey)"
    }
    
    
    
    
}
