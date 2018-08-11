//
//  Countries.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 28.06.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import SwiftyJSON

import RealmSwift

class Country : Object , Uploadable {

    
    // Mark - CustomStringConvertible

    //override var description: String { return "\(name)" }
    
    @objc dynamic var id : Int = 0
    @objc dynamic var cty : String = String()
     @objc dynamic var name : String = String()
    
   
 //   init(id: Int, version: Int,cty: String, ctyShort: String, name: String) {
 //       self.id = id
 //       self.version = version
 //       self.cty = cty
 //       self.name = name
        
 //   }

    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var resourceURL: URL {
        return URL(string: "\(BASE_APP_URL)/api/countries")!
    }
 
    private enum CodingKeys: String, CodingKey {
        case id, cty,name  }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
         try container.encode(cty, forKey: .cty)
        try container.encode(name, forKey: .name)

        
        
    }
    
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        cty = try container.decode(String.self, forKey: .cty)
        name = try container.decode(String.self, forKey: .name)
   
        
    }
    
    // Mark - decode
     convenience init(from json: JSON) {
        self.init()
        self.id = json["id"].int!
        self.cty = (json["cty"].null == NSNull()) ? "" : json["cty"].string!
        self.name =  (json["name"].null == NSNull()) ? "" : json["name"].string!
        
    }
    
    
}
