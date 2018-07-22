//
//  User.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 28.06.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class User : Object , Uploadable{
    @objc dynamic var  id : Int = 0
    @objc dynamic var  username : String = String()
    @objc dynamic var  password : String = String()
    var  client : Partner?
    @objc dynamic var  email : String = String()
    @objc dynamic var  firstName : String = String()
    @objc dynamic var  lastName : String = String()
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
    
    
    convenience init(from json: JSON) {
        self.init()
        self.id = json["id"].int!
        self.username =  (json["infoText"].null == NSNull()) ? String() : json["infoText"].string!
        self.password =  (json["infoText"].null == NSNull()) ? String() : json["infoText"].string!
        self.client = (json["client"].null == NSNull()) ? nil : Partner(from: json["client"])
        self.email =  (json["infoText"].null == NSNull()) ? String() : json["infoText"].string!
        self.firstName =  (json["infoText"].null == NSNull()) ? String() : json["infoText"].string!
        self.lastName =  (json["infoText"].null == NSNull()) ? String() : json["infoText"].string!
        self.personNumber =  (json["infoText"].null == NSNull()) ? String() : json["infoText"].string!
        self.costCenter   = (json["costCenter"].null == NSNull()) ? nil : Partner(from: json["costCenter"])
       // self.trips = trips
   
    }
    

}
