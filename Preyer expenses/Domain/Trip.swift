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
    @objc dynamic var  costCenter : Int = 0
    @objc dynamic var  country : Int = 1
    @objc dynamic var  payor : Int = 0
    let  receipts = List<Receipt>()
    let  travelDays = List<TravelDay>()
    @objc dynamic var user : Int = 0

 
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var resourceURL: URL {
        return URL(string: "\(BASE_APP_URL)/api/trips")!
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, beginning, ending,exports,infoText,reason,upfront,costCenter,country,payor,receipts,travelDays,user
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var referObj = Refer()
        try container.encode(id, forKey: .id)
        try container.encode(beginning, forKey: .beginning)
        try container.encode(ending, forKey: .ending)
        try container.encode(exports, forKey: .exports)
        try container.encode(infoText, forKey: .infoText)
        try container.encode(reason, forKey: .reason)
        try container.encode(upfront, forKey: .upfront)
        referObj.id = self.costCenter
        try container.encode(referObj, forKey: .costCenter)
        referObj.id = self.country
        try container.encode(referObj, forKey: .country)
        referObj.id = self.payor
        try container.encode(referObj, forKey: .payor)
        let receiptsArray = Array(self.receipts)
        try container.encode(receiptsArray, forKey: .reason)
        let travelDaysArray = Array(self.travelDays)
        try container.encode(travelDaysArray, forKey: .travelDays)
        referObj.id = self.user
        try container.encode(referObj, forKey: .user)
    }

    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        beginning = try container.decode(Date.self, forKey: .beginning)
        ending = try container.decode(Date.self, forKey: .ending)
        exports = try container.decode(Int.self, forKey: .exports)
        infoText = try container.decode(String.self, forKey: .infoText)
        reason = try container.decode(String.self, forKey: .reason)
        upfront = try container.decode(Float.self, forKey: .reason)
 
        let costCenterReferObj = try container.decode(Refer.self, forKey: .costCenter)
       costCenter = costCenterReferObj.id
        
        let countryReferObj = try container.decode(Refer.self, forKey: .country)
        country = countryReferObj.id
        
        let payorReferObj = try container.decode(Refer.self, forKey: .payor)
        payor = payorReferObj.id
        if let arr = try container.decodeIfPresent(Array<Receipt>.self, forKey: .receipts) {
            receipts.append(objectsIn: arr)
        }
        if let arr = try container.decodeIfPresent(Array<TravelDay>.self, forKey: .travelDays) {
            travelDays.append(objectsIn: arr)
        }
        let userReferObj = try container.decode(Refer.self, forKey: .user)
        user = userReferObj.id
    }
   
 
  
}
