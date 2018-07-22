//
//  PaymentType.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 21.07.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class PaymentType: Object , Uploadable {
    @objc dynamic var id : Int = 0
    @objc dynamic var pmnt : String = String()
    @objc dynamic var name : String = String()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var resourceURL: URL {
        return URL(string: "\(BASE_APP_URL)/api/paymenttypes")!
    }
    // Mark - decode
    convenience init(from json: JSON) {
        self.init()
        self.id = json["id"].int!
        self.pmnt = (json["pmnt"].null == NSNull()) ? String() : json["pmnt"].string!
        self.name =  (json["name"].null == NSNull()) ? String() : json["name"].string!
        
    }
}