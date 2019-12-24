//
//  ParseClient.swift
//  On The Map
//
//  Created by Michael Haviv on 12/8/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

import Foundation

class ParseClient {
    
    public func getLocations(completion: ((_ locations: [StudentData]?) -> ())?) {
        APIManager.sharedInstance().getRequest(endpoint: .location(limit:20)) { (data, response, error) in
            guard error == nil, let data = data else {
                completion?(nil)
                return
            }
            
            do {
                let result:ParseResponse = try JSONDecoder().decode(ParseResponse<StudentData>.self, from: data)
                completion?(result.results)
//                self.skipOverPlaceholderName(resultsArray: result.results)
            } catch {
                print("Cannot Parse Location Data!")
                completion?(nil)
            }
        }
    }
    
//    func skipOverPlaceholderName(resultsArray: [StudentData]) {
//        for person in 0..<(resultsArray.count) {
//            print("This is \(person)")
////            if firstName == "first name" || lastName == "last name" {
////                continue
////            }
//        }
//    }
    
}
