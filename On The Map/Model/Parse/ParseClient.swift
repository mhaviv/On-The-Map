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
        APIManager.sharedInstance().getRequest(endpoint: .location(limit:100)) { (data, response, error) in
            guard error == nil, let data = data else {
                completion?(nil)
                return
            }
            
            do {
                let result:ParseResponse = try JSONDecoder().decode(ParseResponse<StudentData>.self, from: data)
                completion?(result.results)
            } catch {
                print("")
                completion?(nil)
            }
            
        }
    }
    
//    ParseClient().getLocations { (results) in
//        guard let locations = results else {
//            print("nothing")
//            return
//        }
//        
//        let c = locations.map { (user) -> (Double, Double) in
//            return (user.latitude, user.longitude)
//        }
//        print(c)
//    }

}
