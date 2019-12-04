//
//  UdacityClient.swift
//  On The Map
//
//  Created by Michael Haviv on 11/18/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

import Foundation

class UdacityClient {
    
    enum Endpoint {
        case sessionURL
        case userURL
        
        var stringValue: String {
            switch self {
            case .sessionURL:
                return "https://onthemap-api.udacity.com/v1/session"
            case .userURL:
                return "https://onthemap-api.udacity.com/v1/users"
            }
        }
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
    }
    

    func taskForGetRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(SessionResponse.self, from: data) as! Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
            let range = 5..<data.count
            let newData = data.subdata(in: range) /* subset response data! */
            print(String(data: newData, encoding: .utf8)!)
        }
        task.resume()
        
        return task
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
        
        for cookie in sharedCookieStorage.cookies! {
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
                print(response.session?.expiration)
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
