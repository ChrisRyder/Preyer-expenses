//
//  CCyRate.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 21.07.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import RealmSwift


class CcyRate: Object ,Uploadable {
    
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
}

