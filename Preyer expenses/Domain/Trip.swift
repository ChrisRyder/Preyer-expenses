//
//  Trip.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 28.06.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import SwiftyJSON

class Trip  : Comparable, CustomStringConvertible {
    var description: String { return "\(id)" }

    var beginning : Date?
    var costCenter : Partner?
    var countries : Country?
    var ending  : Date?
    var exports : Bool?
    let id : Int
    var infoText :String
    var payor : Partner?
    var reason : String
    var receipts  : [Receipts]?
    var travelDays : [TravelDays]?
    var upfront : Float = 0
    var user : Int?
    var status : String

    init(id: Int, infoText: String, reason: String,beginning : Date, ending : Date, payor: Partner, costCenter: Partner, countries: Country, status: String) {
        self.id = id
        self.infoText = infoText
        self.reason = reason
        self.beginning = beginning
        self.ending = ending
        self.payor = payor
        self.costCenter = costCenter
        self.countries = countries
        self.status = status
    }
    convenience init(json: JSON) {
        print(json)
        let id: Int =  json["id"].int!
        let beginning : Date? = (json["beginning"].null == NSNull()) ? Date() : json["beginning"].date
        let ending : Date? = (json["ending"].null == NSNull()) ? Date() : json["ending"].date
        let reason : String = (json["reason"].null == NSNull()) ? "" : json["reason"].string!
        let infoText : String = (json["infoText"].null == NSNull()) ? "" : json["infoText"].string!
         let status : String = (json["status"].null == NSNull()) ? "" : json["status"].string!
        let payor =  payors.lazy.filter( {return $0.id == json["payor"]["id"].int!}).first!
        
        
//        let costcenterid = json["costCenter"]["id"].int!
//        print(costcenterid)
//        print (partners)
        let costCenter = partners.lazy.filter( {return $0.id == json["costCenter"]["id"].int! }).first!
        
        let countries = countryList.lazy.filter( {return $0.id == json["countries"]["id"].int! }).first!
        
        self.init(id: id, infoText: infoText, reason: reason,beginning : beginning!, ending : ending!, payor: payor, costCenter: costCenter, countries: countries, status: status)
      debugPrint(self)
    }
    func toJSON() -> Dictionary<String, Any> {
        let formatter = DateFormatter()
  //      formatter.dateFormat = "YYYY.MM.dd"
       
        return [
            "beginning" : formatter.string(from: self.beginning!),
            "costCenter" : self.costCenter as Any,
            "countries" : self.countries as Any,
            "ending"  : formatter.string(from: self.ending!),
            "exports" : self.exports as Any,
            "id" : self.id,
            "infoText" : self.infoText,
            "payor" : self.payor as Any,
            "reason" : self.reason,
      //      "receipts"  : self.receipts.map({ $0.toJSON() }),
      //      "travelDays" : self.travelDays.map({ $0.toJSON() }),
            "upfront" : self.upfront,
            "user" : self.user as Any,
            "status" : self.status as Any
        ]
    }
    static func < (lhs: Trip, rhs: Trip) -> Bool {
        return lhs.beginning! < rhs.beginning!
    }
    static func == (lhs: Trip, rhs: Trip)-> Bool {
        return lhs.beginning! == rhs.beginning!
    }
}
