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
    
    private enum CodingKeys: String, CodingKey {
        case id, vhcl, name }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(vhcl, forKey: .vhcl)
        try container.encode(name, forKey: .name)
        
        
        
    }
    
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        vhcl = try container.decode(Int.self, forKey: .vhcl)
        name = try container.decode(String.self, forKey: .name)
        
        
        
    }
    
    convenience init(from json: JSON) {
        self.init()
        self.id = json["id"].int!
        self.vhcl = (json["vhcl"].null == NSNull()) ? 0 : json["vhcl"].int!
        self.name = (json["name"].null == NSNull()) ? String() : json["name"].string!
   
    }
    

}
