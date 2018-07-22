//
//  Reduction.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 21.07.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import SwiftyJSON
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
    
    convenience init(from json: JSON) {
        self.init()
        self.id = json["id"].int!
        self.rdnDate = (json["rdnDate"].null == NSNull()) ? nil : json["rdnDate"].date!
        self.breakfast = (json["breakfast"].null == NSNull()) ? false : json["breakfast"].bool!
        self.lunch = (json["lunch"].null == NSNull()) ? false : json["lunch"].bool!
        self.dinner = (json["dinner"].null == NSNull()) ? false : json["dinner"].bool!
        self.receipt = (json["receipt"].null == NSNull()) ? nil : Receipt(from: json["receipt"])
        self.reductionType = (json["reductionType"].null == NSNull()) ? nil : ReductionType(from: json["reductionType"])
    }
        
}
    

