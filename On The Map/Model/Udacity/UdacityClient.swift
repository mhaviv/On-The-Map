//
//  UdacityClient.swift
//  On The Map
//
//  Created by Michael Haviv on 11/18/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

// Void is used for when function is hit before async call is made it returns nothing but when async call is made it returns the response and error

import Foundation

class UdacityClient {
    
    enum Endpoint {
        static let userID = "user_id"
        
        case sessionURL
        case userURL
        
        var stringValue: String {
            switch self {
            case .sessionURL:
                return "https://onthemap-api.udacity.com/v1/session"
            case .userURL:
                return "https://onthemap-api.udacity.com/v1/users/"
            }
        }
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
    }
    

    func taskForGetRequest(url: URL, completion: @escaping (StudentData?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(nil, error)
                
                return
            }
            
            let range = 5..<data.count
            let newData = data.subdata(in: range) /* subset response data! */
            //print(String(data: newData, encoding: .utf8)!)
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(StudentData.self, from: newData)
                completion(responseObject, nil)
            } catch {
                completion(nil, error)
            }
        }
        
        task.resume()
    }
    
    
    func taskForPostRequest(withURL url: URL, body: Data, completion: @escaping (SessionResponse?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // We cannot encode the body before its converted to raw data
        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil, error)
                
                return
            }
            
            let range = 5..<data.count
            let newData = data.subdata(in: range) /* subset response data! */
            print(String(data: newData, encoding: .utf8)!)
        
            let decoder = JSONDecoder()
            do {
                // decode is taking data, converting it into raw data and then parsing it into JSON
                let responseObject = try decoder.decode(SessionResponse.self, from: newData)
                completion(responseObject, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    func taskForDeleteRequest(withURL url: URL, completion: @escaping (Session?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        guard let cookies = sharedCookieStorage.cookies else {
            // set completion handler here
            return
        }
        
        for cookie in cookies {
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie
            }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil, error)
                return

            }
            
            if error != nil {
                completion(nil, error)
                
                return
            }
            
            let range = 5..<data.count
            let newData = data.subdata(in: range) /* subset response data! */
            print(String(data: newData, encoding: .utf8)!)
            
            let decoder = JSONDecoder()
            
            do {
                let responseObject = try decoder.decode(Session.self, from: newData)
                completion(responseObject, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
        
    func AuthenticateUser(username: String, password: String, _ completion: @escaping (_ response: SessionResponse?, _ error: Error?) -> Void) {

        let url = Endpoint.sessionURL.url

        let body = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)!

        taskForPostRequest(withURL: url, body: body) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func GetUserData(userId: String, completion: @escaping (_ response: StudentData?, _ error: Error?) -> Void) {
        
        let url = Endpoint.sessionURL.url.appendingPathComponent(Endpoint.userID.byReplacingKey(Endpoint.userID, withValue: userId))
        
        taskForGetRequest(url: url) { response, error in
            if let response = response {
                
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func LogoutUser(completion: @escaping (_ response: Session?, _ error: Error?) -> Void) {
        
        let url = Endpoint.sessionURL.url
        
        taskForDeleteRequest(withURL: url) { response, error in
            if let response = response {
                completion(response, nil)
                // whereever you are getting a callback, you should present login screen (by changing window's root ViewController)
            } else {
                completion(nil, error)
            }
            
        }
        
    }
    
   class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}

extension String {

    /// Returns a string in which the key is substituted with the given value, if found.
    /// - Parameters:
    ///     - key: the key to be found and replaced.
    ///     - value: the value to be used when replacing the key.
    /// - Returns: the replaced string.
    func byReplacingKey(_ key: String, withValue value: String) -> String {
        return replacingOccurrences(of: "{\(key)}", with: value)
    }
}
