//
//  CostCenter.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 28.06.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Partner : Object , Uploadable {
    //var description: String { return "\(name)" }
    
    @objc dynamic var id : Int = 0
    @objc dynamic var par : String = String()
    @objc dynamic var name : String = String()
    @objc dynamic var payor : Bool = false
    @objc dynamic var client : Bool = false
    @objc dynamic var costCenter : Bool = false
    @objc dynamic var hidden : Bool = false
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var resourceURL: URL {
        return URL(string: "\(BASE_APP_URL)/api/partners")!
    }
    private enum CodingKeys: String, CodingKey {
        case id, par, name,payor,client,costCenter,hidden
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        par = try container.decode(String.self, forKey: .par)
        name = try container.decode(String.self, forKey: .name)
        payor = try container.decode(Bool.self, forKey: .payor)
        client = try container.decode(Bool.self, forKey: .client)
        costCenter = try container.decode(Bool.self, forKey: .costCenter)
        hidden = try container.decode(Bool.self, forKey: .hidden)
  
    }
    
    convenience init(from json: JSON) {
        self.init()
        self.id =  json["id"].int!
        self.par = (json["par"].null == NSNull()) ? String(): json["par"].string!
        self.name  = (json["name"].null == NSNull()) ? String() : json["name"].string!
        self.payor  = (json["payor"].null == NSNull()) ? false : json["payor"].bool!
        self.client  = (json["client"].null == NSNull()) ? false : json["client"].bool!
        self.costCenter   = (json["costCenter"].null == NSNull()) ? false : json["costCenter"].bool!
        self.hidden   = (json["hidden"].null == NSNull()) ? false : json["hidden"].bool!
    }
    
}
