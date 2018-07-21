//
//  User.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 28.06.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import RealmSwift

class User : Object , Uploadable{
    @objc dynamic var  id : Int = 0
    @objc dynamic var  username : String = String()
    @objc dynamic var  password : String = String()
    var  client : Partner?
    @objc dynamic var  email : String = String()
    @objc dynamic var  firstName : String = String()
    @objc dynamic var  lastName : String = String()
    @objc dynamic var  userName : String = String()
    @objc dynamic var  personNumber : String = String()
    var  costCenter : Partner?
    @objc dynamic var  token : String = String()
    var  trips = List<Trip>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var resourceURL: URL {
        return URL(string: "\(BASE_APP_URL)/api/users")!
    }
}
