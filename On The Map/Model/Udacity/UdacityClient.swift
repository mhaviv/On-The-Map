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
    
    public func AuthenticateUser(username: String, password: String, completion: @escaping (_ response: SessionResponse?, _ error: Error?) -> Void) {
        
        let encoder = JSONEncoder()
        
        let userPayload = UserPayload(username: username, password: password)
        let payload = UdacityPayload(payload: userPayload)
        
        do {
            let encodedData = try encoder.encode(payload)
            //send off to network
            //UdacityClient().AuthenticateUser(username: username, password: password, data: data)
            APIManager.sharedInstance().postRequest(endpoint: APIConstants.Endpoint.session, data: encodedData) { (dataResp, response, error) in
                guard let data = dataResp else {
                    print(error?.localizedDescription as Any)
                    completion(nil, error)

                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 403 {
                    completion(nil, NSError(domain: "Login API", code: 403, userInfo: ["underlyingError":"Invalid Username or Password"]))

                    return
                }


                let range = 5..<data.count
                let newData = data.subdata(in: range)
                print(String(data: newData, encoding: .utf8) ?? "no data")
                
                let decoder = JSONDecoder()
                
                do {
                    let responseObject = try decoder.decode(SessionResponse.self, from: newData)
                    
                    completion(responseObject, nil)
                } catch {
                    completion(nil, error)
                }
           }
        } catch {
            print(error.localizedDescription)
            completion(nil, error)
        }
       
    }
    
    public func LogoutUser(completion: @escaping (_ response: SessionResponse.Session?, _ error: Error?) -> Void) {
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        guard let cookies = sharedCookieStorage.cookies else {
            completion(nil, NSError(domain: "Logout Delete API", code: 1001, userInfo: ["underlyingError": "Cookie Not Found"]))
                       
            return
        }
        
        for cookie in cookies {
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie
            }
        }
        
        if let xsrfCookie = xsrfCookie {
            APIManager.sharedInstance().deleteRequest(endpoint: APIConstants.Endpoint.session, cookie: xsrfCookie) { (dataResp, response, error) in
                guard let data = dataResp else {
                    print(error?.localizedDescription as Any)
                    completion(nil, error)
                    
                    return
                }
                
                let range = 5..<data.count
                let newData = data.subdata(in: range)
                print(String(data: newData, encoding: .utf8) ?? "no data")
                
                let decoder = JSONDecoder()
                
                do {
                    let responseObject = try decoder.decode(SessionResponse.Session.self, from: newData)
                    
                    completion(responseObject, nil)
                } catch {
                    completion(nil, error)
                }
            }
        } else {
            completion(nil, NSError(domain: "Logout Delete API", code: 1002, userInfo: ["underlyingError": "xsrfCookie is nil"]))
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
