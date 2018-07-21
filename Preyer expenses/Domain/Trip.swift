//
//  Trip.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 28.06.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import RealmSwift

class Trip : Object , Uploadable { 
    @objc dynamic var id : Int = 0
    @objc dynamic var  beginning : Date?
    @objc dynamic var  ending  : Date?
    @objc dynamic var  exports : Int = 0
    @objc dynamic var  infoText : String = String()
    @objc dynamic var  reason : String = String()
    @objc dynamic var  upfront : Float = 0
    var  costCenter : Partner?
    var  country : Country?
    var  payor : Partner?
    let  receipts = List<Receipt>()
    let  travelDays = List<TravelDay>()
    var user : User?
/*
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
  */
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var resourceURL: URL {
        return URL(string: "\(BASE_APP_URL)/api/trips")!
    }
}
