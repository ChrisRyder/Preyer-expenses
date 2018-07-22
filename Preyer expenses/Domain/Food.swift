//
//  Food.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 21.07.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Food: Object, Uploadable {
    @objc dynamic var id : Int = 0
    @objc dynamic var indRefund : Float = 0.0
    @objc dynamic var infoText : String = String()
    @objc dynamic var noPaying : Bool = false
    var country : Country?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var resourceURL: URL {
        return URL(string: "\(BASE_APP_URL)/api/food")!
    }

    // Mark - decode
    convenience init(from json: JSON) {
        self.init()
        self.id = json["id"].int!
        self.indRefund = (json["indRefund"].null == NSNull()) ? 0.0: json["indRefund"].float!
        self.infoText =  (json["infoText"].null == NSNull()) ? String() : json["infoText"].string!
        self.noPaying  = (json["noPaying"].null == NSNull()) ? false : json["noPaying"].bool!
        self.country  = (json["countries"].null == NSNull()) ? nil : Country(from: json["countries"])
        
    }
    
}
