//
//  Trip.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 28.06.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Trip : Object , Uploadable  {
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

 
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var resourceURL: URL {
        return URL(string: "\(BASE_APP_URL)/api/trips")!
    }
    

   
    convenience init(from json: JSON) {
        self.init()
        self.id =  json["id"].int!
        self.beginning = (json["beginning"].null == NSNull()) ? Date() : json["beginning"].date
        self.ending = (json["ending"].null == NSNull()) ? Date() : json["ending"].date
        self.exports = (json["reason"].null == NSNull()) ? 0 : json["reason"].int!
        self.infoText = (json["infoText"].null == NSNull()) ? String() : json["infoText"].string!
        self.reason = (json["reason"].null == NSNull()) ? String() : json["reason"].string!
        self.upfront = (json["reason"].null == NSNull()) ? 0.0 : json["reason"].float!
        self.costCenter   = (json["costCenter"].null == NSNull()) ? nil : Partner(from: json["costCenter"])
        self.country   = (json["countries"].null == NSNull()) ? nil :  Country(from: json["countries"])
        self.payor = (json["payor"].null == NSNull()) ? nil : Partner(from: json["payor"])
        if json["receipts"].null != NSNull() {
            for item in json["receipts"].arrayValue {
                let obj = Receipt(from: item)
                self.receipts.append(obj)
            }
          }
        if json["travelDays"].null != NSNull() {
            for item in json["travelDays"].arrayValue {
                let obj = TravelDay(from: item)
                self.travelDays.append(obj)
            }
        }
     
    }
  
}
