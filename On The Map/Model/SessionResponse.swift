//
//  Session.swift
//  On The Map
//
//  Created by Michael Haviv on 11/21/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

import Foundation

struct Session: Decodable {
    let id: String
    let expiration: String
}

struct Account: Decodable {
    let registered: Bool
    let key: String
}

struct SessionResponse: Decodable {
    let account: Account
    let session: Session
}

