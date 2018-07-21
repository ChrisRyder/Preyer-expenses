//
//  InputTaxType.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 21.07.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
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
}