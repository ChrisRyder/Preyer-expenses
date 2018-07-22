//
//  Receipts.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 28.06.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Receipt: Object , Uploadable  {
    @objc dynamic var id : Int = 0
    @objc dynamic var amontQc : Float = 0.0
    @objc dynamic var ccyRate : Float = 0.0
    @objc dynamic var rcptDate : Date?
    @objc dynamic var rcptText : String = String()
    @objc dynamic var rcptF : Bool = false
    @objc dynamic var infoText : String = String()
    @objc dynamic var dayCheckIn : Date?
    @objc dynamic var dayCheckOut : Date?
    var trip = LinkingObjects(fromType: Trip.self, property: "receipts")
    var payor : Partner?
    var costCenter : Partner?
    var  inputTaxType : InputTaxType?
    var receiptType : ReceiptType?
    var paymentType : PaymentType?
    var currency : Currency?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var resourceURL: URL {
        return URL(string: "\(BASE_APP_URL)/api/receipts")!
    }
    
    
    convenience init(from json: JSON)
        {
        self.init()
        self.id =  json["id"].int!
        self.amontQc = (json["amontQc"].null == NSNull()) ? 0.0 : json["amontQc"].float!
        self.ccyRate = (json["ccyRate"].null == NSNull()) ? 0.0 : json["ccyRate"].float!
        self.rcptDate = (json["rcptDate"].null == NSNull()) ? nil : json["rcptDate"].date!
        self.rcptText = (json["rcptText"].null == NSNull()) ? String(): json["rcptText"].string!
        self.rcptF = (json["rcptF"].null == NSNull()) ? false : json["rcptF"].bool!
        self.infoText = (json["infoText"].null == NSNull()) ? String() : json["infoText"].string!
        self.dayCheckIn = (json["dayCheckIn"].null == NSNull()) ? nil : json["dayCheckIn"].date!
        self.dayCheckOut = (json["dayCheckOut"].null == NSNull()) ? nil : json["dayCheckOut"].date!
        
        self.payor = (json["payor"].null == NSNull()) ? nil : Partner(from: json["payor"])
        self.costCenter = (json["costCenter"].null == NSNull()) ? nil : Partner(from: json["costCenter"])
        self.inputTaxType = (json["inputTaxType"].null == NSNull()) ? nil : InputTaxType(from: json["inputTaxType"])
        self.receiptType = (json["receiptType"].null == NSNull()) ? nil : ReceiptType(from:  json["receiptType"])
        self.paymentType = (json["paymentType"].null == NSNull()) ?nil : PaymentType(from: json["paymentType"])
        self.currency = (json["currency"].null == NSNull()) ? nil : Currency(from: json["currency"])
        
    }
    
  
}
