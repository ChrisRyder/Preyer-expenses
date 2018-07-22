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
    
    // Mark - decode
    convenience init(from json: JSON) {
        self.init()
        self.id = json["id"].int!
        self.tax = (json["tax"].null == NSNull()) ? String() : json["tax"].string!
        self.name =  (json["name"].null == NSNull()) ? String() : json["name"].string!
        self.domestic  = (json["domestic"].null == NSNull()) ? false : json["domestic"].bool!
        
    }
}
