//
//  ParseClient.swift
//  On The Map
//
//  Created by Michael Haviv on 12/8/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

import Foundation

class ParseClient {
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
    public func getLocations(completion: ((_ locations: [StudentData]?) -> ())?) {
        APIManager.sharedInstance().getRequest(endpoint: .location(limit: 600, skip: 0, order: "-updatedAt")) { (data, response, error) in
            guard error == nil, let data = data else {
                completion?(nil)
                return
            }
            
            do {
                let result:ParseResponse = try JSONDecoder().decode(ParseResponse<StudentData>.self, from: data)
                completion?(result.results)
            } catch {
                print("Cannot Parse Location Data!")
                completion?(nil)
            }
        }
    }
    // [String:Any]
    public func postLocations(studentData: StudentData, completion: ((_ successResponse: [StudentDataResponse]?) -> ())?) {
        // Decode and encode student data to convert it to Data type
        guard let studentDataDict = try? JSONDecoder().decode([String: String].self, from: JSONEncoder().encode(studentData)) else { return }
        guard let data = try? JSONSerialization.data(withJSONObject: studentDataDict, options: []) else { return }

        APIManager.sharedInstance().postRequest(endpoint: .postLocation, data: data) { (data, response, error) in
            guard error == nil, let data = data else {
                completion?(nil)
                return
            }
            
            do {
                let result:ParseResponse = try JSONDecoder().decode(ParseResponse<StudentDataResponse>.self, from: data)
                completion?(result.results)
                print("parsed location!!!!!")
            } catch {
                print("Cannot Parse Location Data!")
                completion?(nil)
            }
            
        }
    }
}

