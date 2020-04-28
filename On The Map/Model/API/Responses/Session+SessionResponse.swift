//
//  Session+SessionResponse.swift
//  On The Map
//
//  Created by Michael Haviv on 4/15/20.
//  Copyright © 2020 Michael Haviv. All rights reserved.
//

import Foundation

extension Session {
    init(response: SessionResponse) {
        //TODO: create the session
        self.init(expiration: .init(), provider: .udacity)
    }
}
