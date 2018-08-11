//
//  Currency.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 21.07.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Currency: Object , Uploadable{
    @objc dynamic var id : Int = 0
    @objc dynamic var cur : String = String()
    @objc dynamic var name : String = String()
    var country : Country?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var resourceURL: URL {
        return URL(string: "\(BASE_APP_URL)/api/currencies")!
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, cur, name, country  }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(cur, forKey: .cur)
        try container.encode(name, forKey: .name)
        try container.encode(country, forKey: .country)
        
        
        
    }
    
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        cur = try container.decode(String.self, forKey: .cur)
        name = try container.decode(String.self, forKey: .name)
        country = try container.decode(Country?.self, forKey: .country)

        
    }
    
    // Mark - decode
    convenience init(from json: JSON) {
        self.init()
        self.id = json["id"].int!
        self.cur = (json["cur"].null == NSNull()) ? String() : json["cur"].string!
        self.name =  (json["name"].null == NSNull()) ? String() : json["name"].string!
        self.country  = (json["countries"].null == NSNull()) ? nil : Country(from: json["countries"])

    }
    
}
