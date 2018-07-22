//
//  Vehicle.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 21.07.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Vehicle : Object , Uploadable {
    @objc dynamic var  id : Int = 0
    @objc dynamic var  vhcl : Int = 0
    @objc dynamic var  name : String = String()
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var resourceURL: URL {
        return URL(string: "\(BASE_APP_URL)/api/vehicles")!
    }
    
    convenience init(from json: JSON) {
        self.init()
        self.id = json["id"].int!
        self.vhcl = (json["vhcl"].null == NSNull()) ? 0 : json["vhcl"].int!
        self.name = (json["name"].null == NSNull()) ? String() : json["name"].string!
   
    }
    

}
