//
//  APIConstants.swift
//  On The Map
//
//  Created by Michael Haviv on 12/11/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

import Foundation

class APIConstants {
    
    static let baseURL = "https://onthemap-api.udacity.com/v1/"

    enum RequestType: String {
        case GET
        case POST
        case DELETE
        case PUT
    }
    
    enum Endpoint {

        static let userID = "user_id"
        
        case session
        case user
        case location(limit: Int, skip: Int, order: String)
        case postLocation
        
        func url() -> String {
            switch self {
            case .session:
                return baseURL + "session"
            case .user:
                return baseURL + "users/"
            case .location(let limit, let skip, let order):
                return baseURL + "StudentLocation?limit=\(limit)&skip=\(skip)&order=\(order)"
            case .postLocation:
                return baseURL + "StudentLocation"
            }
        }
    }
    
}

