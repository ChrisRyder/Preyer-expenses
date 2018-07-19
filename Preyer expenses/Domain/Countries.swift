//
//  Countries.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 28.06.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import SwiftyJSON

class Country : Comparable , CustomStringConvertible  {
    static func < (lhs: Country, rhs: Country) -> Bool {
        return lhs.name < rhs.name
    }
    
    var description: String { return "\(name)" }
    
    static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.name == rhs.name
    }
    
    let id : Int
    var version : Int
    var cty : String
    var ctyShort : String
    var name : String
    
    init(id: Int, version: Int,cty: String, ctyShort: String, name: String) {
        self.id = id
        self.version = version
        self.cty = cty
        self.ctyShort = ctyShort
        self.name = name
        
    }
    convenience init(json: JSON) {
        
        let id = json["id"].int!
        let version = (json["version"].null == NSNull()) ? 0 : json["version"].int!
        let cty = (json["cty"].null == NSNull()) ? "" : json["cty"].string!
        let ctyShort =  (json["ctyShort"].null == NSNull()) ? "" : json["ctyShort"].string!
        let name =  (json["name"].null == NSNull()) ? "" : json["name"].string!
        self.init(id: id, version: version,cty: cty, ctyShort: ctyShort, name: name)
        
    }
    
}
