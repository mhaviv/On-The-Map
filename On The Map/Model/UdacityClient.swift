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
    
    func taskForPostRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    print("No data found")
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                    print("success!")
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(SessionResponse.self, from: data) as! Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                        print("here!")
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                        print("there!")
                    }
                }
            }
            let range = 5..<data.count
            let newData = data.subdata(in: range) /* subset response data! */
            print(String(data: newData, encoding: .utf8)!)
        }
        task.resume()
    }
        
    func AuthenticateUser(username: String, password: String, _ completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {

        let url = Endpoint.sessionURL.url

        let body = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)!

        taskForPostRequest(url: url, responseType: Session.self, body: body) { response, error in
            if let response = response {
                print(response.expiration)
                completion(true, nil)
            } else {
                completion(false, error?.localizedDescription as? Error)
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
