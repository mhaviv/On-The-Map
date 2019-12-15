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
                   print(error?.localizedDescription)
                   completion(nil, error)
                   
                   return
               }
                
                // need to check 403
               // if response.
               
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
    
    public func LogoutUser(completion: @escaping (_ response: Session?, _ error: Error?) -> Void) {
        
//        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
//        request.httpMethod = "DELETE"
//        var xsrfCookie: HTTPCookie? = nil
//        let sharedCookieStorage = HTTPCookieStorage.shared
//        for cookie in sharedCookieStorage.cookies! {
//          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
//        }
        
//        if let xsrfCookie = xsrfCookie {
//          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
//        }
//        let session = URLSession.shared
//        let task = session.dataTask(with: request) { data, response, error in
//          if error != nil { // Handle error…
//              return
//          }
//          let range = Range(5..<data!.count)
//          let newData = data?.subdata(in: range) /* subset response data! */
//          print(String(data: newData!, encoding: .utf8)!)
//        }
//        task.resume()
        
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
//            let requestURLString = APIConstants.Endpoint.session.url()
//            var request = URLRequest(url: URL(string: requestURLString)!)
//            request.httpMethod = "DELETE"
//            print("Here is request: \(request)")
//            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            APIManager.sharedInstance().deleteRequest(endpoint: APIConstants.Endpoint.session, cookie: xsrfCookie) { (dataResp, response, error) in
                guard let data = dataResp else {
                    print(error?.localizedDescription)
                    completion(nil, error)
                    
                    return
                }
                
                let range = 5..<data.count
                let newData = data.subdata(in: range)
                print(String(data: newData, encoding: .utf8) ?? "no data")
                
                let decoder = JSONDecoder()
                
                do {
                    let responseObject = try decoder.decode(Session.self, from: newData)
                    
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
//    func taskForDeleteRequest(withURL url: URL, completion: @escaping (Session?, Error?) -> Void) {
//        var request = URLRequest(url: url)
//        request.httpMethod = "DELETE"
//        var xsrfCookie: HTTPCookie? = nil
//        let sharedCookieStorage = HTTPCookieStorage.shared
//
//        guard let cookies = sharedCookieStorage.cookies else {
//            // set completion handler here
//            return
//        }
//
//        for cookie in cookies {
//            if cookie.name == "XSRF-TOKEN" {
//                xsrfCookie = cookie
//            }
//        }
//
//        if let xsrfCookie = xsrfCookie {
//            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
//        }
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data else {
//                completion(nil, error)
//                return
//
//            }
//
//            if error != nil {
//                completion(nil, error)
//
//                return
//            }
//
//            let range = 5..<data.count
//            let newData = data.subdata(in: range) /* subset response data! */
//            print(String(data: newData, encoding: .utf8)!)
//
//            let decoder = JSONDecoder()
//
//            do {
//                let responseObject = try decoder.decode(Session.self, from: newData)
//                completion(responseObject, nil)
//            } catch {
//                completion(nil, error)
//            }
//        }
//        task.resume()
//    }
//
//
//
//
   
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
