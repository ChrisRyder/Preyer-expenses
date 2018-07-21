//
//  Reduction.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 21.07.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import RealmSwift

class Reduction: Object, Uploadable {
    @objc dynamic var id : Int = 0
    @objc dynamic var rdnDate : Date?
    @objc dynamic var breakfast : Bool = false
    @objc dynamic var lunch : Bool = false
    @objc dynamic var dinner : Bool = false
    var receipt : Receipt?
    var reductionType : ReductionType?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var resourceURL: URL {
        return URL(string: "\(BASE_APP_URL)/api/reductions")!
    }
}
