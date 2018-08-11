//
//  InputTaxType.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 21.07.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class InputTaxType: Object , Uploadable{
    @objc dynamic var id : Int = 0
    @objc dynamic var tax : String = String()
    @objc dynamic var name : String = String()
    @objc dynamic var domestic : Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var resourceURL: URL {
        return URL(string: "\(BASE_APP_URL)/api/inputtytypes")!
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, tax, name,domestic }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(tax, forKey: .tax)
        try container.encode(name, forKey: .name)
        try container.encode(domestic, forKey: .domestic)

        
        
    }
    
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        tax = try container.decode(String.self, forKey: .tax)
        name = try container.decode(String.self, forKey: .name)
        domestic = try container.decode(Bool.self, forKey: .domestic)

        
    }
    
    // Mark - decode
    convenience init(from json: JSON) {
        self.init()
        self.id = json["id"].int!
        self.tax = (json["tax"].null == NSNull()) ? String() : json["tax"].string!
        self.name =  (json["name"].null == NSNull()) ? String() : json["name"].string!
        self.domestic  = (json["domestic"].null == NSNull()) ? false : json["domestic"].bool!
        
    }
}
