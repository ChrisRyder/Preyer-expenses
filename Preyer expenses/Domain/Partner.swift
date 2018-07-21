//
//  CostCenter.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 28.06.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import RealmSwift

class Partner : Object , Uploadable{
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
}
