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
    
    private enum CodingKeys: String, CodingKey {
        case id, stlmt, name }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(stlmt, forKey: .stlmt)
        try container.encode(name, forKey: .name)
        
    }
    
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        stlmt = try container.decode(Int.self, forKey: .stlmt)
        name = try container.decode(String.self, forKey: .name)
        
    }
    
    convenience init(from json: JSON)  {
        self.init()
        self.id =  json["id"].int!
        self.name  = (json["name"].null == NSNull()) ? String() : json["name"].string!
        self.stlmt  = (json["stlmt"].null == NSNull()) ? 0 : json["stlmt"].int!
        
    }
}
