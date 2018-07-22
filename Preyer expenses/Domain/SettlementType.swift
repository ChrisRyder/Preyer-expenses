//
//  SettlementType.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 21.07.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class SettlementType: Object , Uploadable {
    @objc dynamic var id : Int = 0
    @objc dynamic var name : String = String()
    @objc dynamic var stlmt : Int = 0
 
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var resourceURL: URL {
        return URL(string: "\(BASE_APP_URL)/api/settlementtypes")!
    }
    
    convenience init(from json: JSON)  {
        self.init()
        self.id =  json["id"].int!
        self.name  = (json["name"].null == NSNull()) ? String() : json["name"].string!
        self.stlmt  = (json["stlmt"].null == NSNull()) ? 0 : json["stlmt"].int!
        
    }
}
