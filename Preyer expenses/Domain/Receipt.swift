//
//  Receipts.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 28.06.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import RealmSwift

class Receipt: Object , Uploadable {
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
}
