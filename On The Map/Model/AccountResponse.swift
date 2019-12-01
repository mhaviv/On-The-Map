//
//  Account.swift
//  On The Map
//
//  Created by Michael Haviv on 11/21/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

import Foundation

struct AccountResponse: Decodable {
    let registered : Bool
    let key : String
}
