//
//  APIHelpers.swift
//  On The Map
//
//  Created by Michael Haviv on 12/11/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

import Foundation

class APIManager: API {
    
    // MARK: shared singleton instance
    class func sharedInstance() -> APIManager {
        struct Singleton {
            static var sharedInstance = APIManager()
        }
        
        return Singleton.sharedInstance
    }
    
    // MARK: Request Method
    static func request(data: Data? = nil, urlString: String, type: APIConstants.RequestType) -> URLRequest? {
        guard let url = URL(string: urlString) else {
            
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpBody = data
        
        if type != .DELETE {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        
        request.httpMethod = type.rawValue
        
        return request
    }
    
    // MARK: Resume Request Method
    // Reusable method to create dataTask
    private func resumeRequest(_ request: URLRequest, completion: @escaping(Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: request) { (dataResp, response, error) in
            DispatchQueue.main.async {
                completion(dataResp, response, error)
            }
        }.resume()
    }
    
    //MARK: GET Request Method
    
    func getRequest(endpoint: APIConstants.Endpoint, data: Data? = nil, completion: @escaping(Data?, URLResponse?, Error?) -> ()) {
        guard let request = Self.request(data: data, urlString: endpoint.url(), type: .GET) else {
            DispatchQueue.main.async {
                completion(nil, nil, nil)
            }
            return
        }
        resumeRequest(request, completion: completion)
    }
    
    //MARK: POST Request Method
    func postRequest(endpoint: APIConstants.Endpoint, data: Data? = nil, completion: @escaping(Data?, URLResponse?, Error?) -> ()) {
        guard let request = Self.request(data: data, urlString: endpoint.url(), type: .POST) else {
            DispatchQueue.main.async {
                completion(nil, nil, nil)
            }
            
            return
        }
        resumeRequest(request, completion: completion)
    }
    
    //MARK: Delete Request Method
    func deleteRequest(endpoint: APIConstants.Endpoint, cookie: HTTPCookie, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        guard var request = Self.request(data: nil, urlString: endpoint.url(), type: .DELETE) else {
            DispatchQueue.main.async {
                completion(nil, nil, nil)
            }
            return
        }
        
        request.setValue(cookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        resumeRequest(request, completion: completion)
    }
}
