//
//  Countries.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 28.06.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
//import SwiftyJSON
import RealmSwift

class Country : Object , Uploadable {
    // Mark - CustomStringConvertible

    //override var description: String { return "\(name)" }
    
    @objc dynamic var id : Int = 0
    @objc dynamic var version : Int = 0
    @objc dynamic var cty : String = String()
    @objc dynamic var ctyShort : String = String()
    @objc dynamic var name : String = String()
    
   
 //   init(id: Int, version: Int,cty: String, ctyShort: String, name: String) {
 //       self.id = id
 //       self.version = version
 //       self.cty = cty
 //       self.ctyShort = ctyShort
 //       self.name = name
        
 //   }
    // Mark - Codable
 //   convenience init(from: JSON) {
 //
 //       let id = from["id"].int!
 //       let version = (from["version"].null == NSNull()) ? 0 : from["version"].int!
 //       let cty = (from["cty"].null == NSNull()) ? "" : from["cty"].string!
 //       let ctyShort =  (from["ctyShort"].null == NSNull()) ? "" : from["ctyShort"].string!
 //       let name =  (from["name"].null == NSNull()) ? "" : from["name"].string!
 //       self.init(id: id, version: version,cty: cty, ctyShort: ctyShort, name: name)
        
 //   }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var resourceURL: URL {
        return URL(string: "\(BASE_APP_URL)/api/countries")!
    }
}
