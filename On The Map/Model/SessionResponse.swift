//
//  Session.swift
//  On The Map
//
//  Created by Michael Haviv on 11/21/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

import Foundation

/*
 Data model is Codable because the response is in JSON. The data is converted into raw data and then parsed to map it to our data model which is SessionResponse
 */

struct Session: Codable {
    let id: String?
    let expiration: String?
}

struct Account: Codable {
    let registered: Bool?
    let key: String?
}

struct SessionResponse: Codable {
    let account: Account?
    let session: Session?
}


