//
//  APIConstants.swift
//  On The Map
//
//  Created by Michael Haviv on 12/11/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

import Foundation
import UIKit

protocol API: class {
    
    static func request(data: Data?, urlString: String, type: RequestType) -> URLRequest?
    
    func getRequest(endpoint: Endpoint, data: Data?, completion: @escaping(_ data: Data?, _ urlResponse: URLResponse?, _ error: Error?) -> ())
    
    func postRequest(endpoint: Endpoint, data: Data?, completion: @escaping(_ data: Data?, _ urlResponse: URLResponse?, _ error: Error?) -> ())
    
    func deleteRequest(endpoint: Endpoint, data: Data?, completion: @escaping(_ data: Data?, _ urlResponse: URLResponse?, _ error: Error?) -> ())

}
