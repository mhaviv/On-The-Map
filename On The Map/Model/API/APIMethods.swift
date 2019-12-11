//
//  APIHelpers.swift
//  On The Map
//
//  Created by Michael Haviv on 12/11/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

import Foundation

extension API {
    
    // MARK: Request Method
    static func request(data: Data? = nil, urlString: String, type: RequestType) -> URLRequest? {
        guard let url = URL(string: urlString) else {
            
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = type.rawValue
        
        return request
    }
    
    
    //MARK: GET Request Method
    func getRequest(endpoint: Endpoint, data: Data? = nil, completion: @escaping(_ data: Data?, _ urlResponse: URLResponse?, _ error: Error?) -> ()) {
        guard let request = Self.request(data: data, urlString: endpoint.url(), type: .GET) else {
            completion(nil, nil, nil)
            
            return
        }
        
        URLSession.shared.dataTask(with: request) { (dataResp, response, error) in
            completion(dataResp, response, error)
        }.resume()
    }
    
    //MARK: POST Request Method
    func postRequest(endpoint: Endpoint, data: Data? = nil, completion: @escaping(_ data: Data?, _ urlResponse: URLResponse?, _ error: Error?) -> ()) {
        guard let request = Self.request(data: data, urlString: endpoint.url(), type: .POST) else {
            completion(nil, nil, nil)
            
            return
        }
        
        URLSession.shared.dataTask(with: request) { (dataResp, response, error) in
            completion(dataResp, response, error)
        }.resume()
    }
    
    func deleteRequest(endpoint: Endpoint, data: Data? = nil, completion: @escaping(_ data: Data?, _ urlResponse: URLResponse?, _ error: Error?) -> ()) {
        guard let request = Self.request(data: data, urlString: endpoint.url(), type: .DELETE) else {
            completion(nil, nil, nil)
            
            return
        }
        
        URLSession.shared.dataTask(with: request) { (dataResp, response, error) in
            completion(dataResp, response, error)
        }.resume()
    }
}
