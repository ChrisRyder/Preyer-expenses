//
//  ReceiptTypes.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 21.07.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class ReceiptType : Object , Uploadable {
    @objc dynamic var id : Int = 0
    @objc dynamic var rcpt : String = String()
    @objc dynamic var name : String = String()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var resourceURL: URL {
        return URL(string: "\(BASE_APP_URL)/api/receipttypes")!
    }
    
    
    
    convenience init(from json: JSON) {
        self.init()
        self.id = json["id"].int!
        self.rcpt = (json["rcpt"].null == NSNull()) ? String(): json["rcpt"].string!
        self.name = (json["name"].null == NSNull()) ? String(): json["name"].string!
        
    }

}
