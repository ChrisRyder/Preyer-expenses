//
//  User.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 28.06.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation

class User {
    var username : String!
    var password : String!
    var token : String = ""
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
        
    }
}
