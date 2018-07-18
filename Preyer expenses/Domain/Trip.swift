//
//  Trip.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 28.06.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation

class Trip {
    var beginning : Date?
    var costCenter : Int?
    var countries : Int?
    var ending  : Date?
    var exports : Bool?
    let id : Int
    var infoText :String
    var payor : Int?
    var reason : String
    var receipts  : [Receipts]?
    var travelDays : [TravelDays]?
    var upfront : Float = 0
    var user : Int?

    init(id: Int, infoText: String, reason: String) {
        self.id = id
        self.infoText = infoText
        self.reason = reason
    }
    
}
