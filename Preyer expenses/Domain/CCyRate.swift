//
//  CCyRate.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 21.07.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift


class CcyRate: Object ,Uploadable  {
    
    //override var description: String { return "\(String(describing: name)): \(String(describing: rate))" }
    
    @objc dynamic var id : Int = 0
    var cur1 : Currency?
    var cur2 : Currency?
    @objc dynamic var rate : Float = 0.0
    @objc dynamic var name : String = String()
    @objc dynamic var comment : String = String()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var resourceURL: URL {
        return URL(string: "\(BASE_APP_URL)/api/ccyrate")!
    }

    // Mark - decode
    convenience init(from json: JSON) {
        self.init()
        self.id = json["id"].int!
        self.cur1 = (json["cur1"].null == NSNull()) ? nil : Currency(from: json["cur1"])
        self.cur2 = (json["cur2"].null == NSNull()) ? nil : Currency(from: json["cur2"])
        self.rate =  (json["ctyShort"].null == NSNull()) ? 0.0 : json["ctyShort"].float!
        self.name =  (json["name"].null == NSNull()) ? String() : json["name"].string!
        self.comment =  (json["comment"].null == NSNull()) ? String() : json["comment"].string!
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, cur1, cur2,rate,name,comment  }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(cur1, forKey: .cur1)
        try container.encode(cur2, forKey: .cur2)
        try container.encode(rate, forKey: .rate)
        try container.encode(name, forKey: .name)
        try container.encode(comment, forKey: .comment)
        
        
    }
    
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        cur1 = try container.decode(Currency?.self, forKey: .cur1)
        cur2 = try container.decode(Currency?.self, forKey: .cur2)
        rate = try container.decode(Float.self, forKey: .rate)
        name = try container.decode(String.self, forKey: .name)
        comment = try container.decode(String.self, forKey: .comment)
        
    }
}

