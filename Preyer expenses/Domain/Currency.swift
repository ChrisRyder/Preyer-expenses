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
    
    // Mark - decode
    convenience init(from json: JSON) {
        self.init()
        self.id = json["id"].int!
        self.cur = (json["cur"].null == NSNull()) ? String() : json["cur"].string!
        self.name =  (json["name"].null == NSNull()) ? String() : json["name"].string!
        self.country  = (json["countries"].null == NSNull()) ? nil : Country(from: json["countries"])

    }
    
}
