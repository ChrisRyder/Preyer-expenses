//
//  Trip.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 28.06.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import SwiftyJSON

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

    init(id: Int, infoText: String, reason: String,beginning : Date, ending : Date, payor: Int, costCenter: Int, countries: Int) {
        self.id = id
        self.infoText = infoText
        self.reason = reason
        self.beginning = beginning
        self.ending = ending
        self.payor = payor
        self.costCenter = costCenter
        self.countries = countries
    }
    convenience init(json: JSON) {
        print(json)
        let id: Int =  json["id"].int!
        let beginning : Date? = (json["beginning"].null == NSNull()) ? Date() : json["beginning"].date
        let ending : Date? = (json["ending"].null == NSNull()) ? Date() : json["ending"].date
        let reason : String = (json["reason"].null == NSNull()) ? "" : json["reason"].string!
        let infoText : String = (json["infoText"].null == NSNull()) ? "" : json["infoText"].string!
        let payor = (json["payor"].null == NSNull()) ? 0 : (json["payor"]["id"].null == NSNull()) ? 0 : json["payor"]["id"].int!
        let costCenter   = (json["costCenter"].null == NSNull()) ? 0 : (json["costCenter"]["id"].null == NSNull()) ? 0 : json["costCenter"]["id"].int!
        let countries   = (json["countries"].null == NSNull()) ? 0 : (json["countries"]["id"].null == NSNull()) ? 0 : json["countries"]["id"].int!
        self.init(id: id, infoText: infoText, reason: reason,beginning : beginning!, ending : ending!, payor: payor, costCenter: costCenter, countries: countries)
    }
    
}
