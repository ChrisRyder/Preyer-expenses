//
//  Receipts.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 28.06.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class Receipt: Object , Uploadable  {
    @objc dynamic var id : Int = 0
    @objc dynamic var amountQc : Float = 0.0
    @objc dynamic var ccyRate : Float = 0.0
    @objc dynamic var rcptDate : Date?
    @objc dynamic var rcptText : String = String()
    @objc dynamic var rcptF : Bool = false
    @objc dynamic var infoText : String = String()
    @objc dynamic var dayCheckIn : Date?
    @objc dynamic var dayCheckOut : Date?
    var trip = LinkingObjects(fromType: Trip.self, property: "receipts")
    @objc dynamic var payor : Int = 0
    @objc dynamic var costCenter : Int = 0
    @objc dynamic var  inputTaxType : Int = 0
    @objc dynamic var receiptType : Int = 0
    @objc dynamic var paymentType : Int = 0
    @objc dynamic var currency : Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var resourceURL: URL {
        return URL(string: "\(BASE_APP_URL)/api/Receipts")!
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, amountQc = "amontQc", ccyRate,rcptDate,rcptText,infoText,rcptF,dayCheckIn,dayCheckOut,payor,costCenter,inputTaxType,receiptType,paymentType,currency
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let referObj = Refer()
        try container.encode(id, forKey: .id)
        try container.encode(amountQc, forKey: .amountQc)
        try container.encode(ccyRate, forKey: .ccyRate)
        try container.encode(rcptDate, forKey: .rcptDate)
        try container.encode(rcptText, forKey: .rcptText)
        try container.encode(infoText, forKey: .infoText)
        try container.encode(rcptF, forKey: .rcptF)
        try container.encode(dayCheckIn, forKey: .dayCheckIn)
        try container.encode(dayCheckOut, forKey: .dayCheckOut)
        referObj.id = self.payor
        try container.encode(referObj, forKey: .payor)
        referObj.id = self.costCenter
        try container.encode(referObj, forKey: .costCenter)
        referObj.id = self.inputTaxType
        try container.encode(referObj, forKey: .inputTaxType)
        referObj.id = self.receiptType
        try container.encode(referObj, forKey: .receiptType)
        referObj.id = self.paymentType
        try container.encode(referObj, forKey: .paymentType)
        referObj.id = self.currency
        try container.encode(referObj, forKey: .currency)
   }
    
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        amountQc = try container.decode(Float.self, forKey: .amountQc)
        ccyRate = try container.decodeIfPresent(Float.self, forKey: .ccyRate) ?? 0.0
        rcptDate = try container.decode(Date.self, forKey: .rcptDate)
        infoText = try container.decodeIfPresent(String.self, forKey: .infoText) ?? ""
        rcptText = try container.decodeIfPresent(String.self, forKey: .rcptText) ?? ""
        rcptF = try container.decodeIfPresent(Bool.self, forKey: .rcptF) ?? false
        dayCheckIn = try container.decode(Date.self, forKey: .dayCheckIn)
        dayCheckOut = try container.decode(Date.self, forKey: .dayCheckOut)
        
        
        if let payorReferObj = try container.decodeIfPresent(Refer.self, forKey: .payor) {
            payor = payorReferObj.id
        }
        if let costCenterReferObj = try container.decodeIfPresent(Refer.self, forKey: .costCenter) {
            costCenter = costCenterReferObj.id
        }
        if let inputTaxTypeReferObj = try container.decodeIfPresent(Refer.self, forKey: .inputTaxType) {
            inputTaxType = inputTaxTypeReferObj.id
        }
        if let receiptTypeReferObj = try container.decodeIfPresent(Refer.self, forKey: .receiptType) {
            receiptType = receiptTypeReferObj.id
        }
        
        if let paymentTypeReferObj = try container.decodeIfPresent(Refer.self, forKey: .paymentType) {
            paymentType = paymentTypeReferObj.id
        }
        if let currencyReferObj = try container.decodeIfPresent(Refer.self, forKey: .currency) {
            currency = currencyReferObj.id
        }
    }
  
    static func getList() {
        
        sessionManager.request(resourceURL).responseJSON { (response: DataResponse<Any>) in
            print("======== Receipt.getList() ===========")
            print("Request: \(String(describing: response.request))")   // original url request
            
       //     print("Response: \(String(describing: response))") // http url response
            print("error: \(String(describing: response.error))")
       //     print("value: \(String(describing: response.value))")
            
            if response.error == nil {
                print("Result: \(String(describing: response.result))")  // response serialization result
                
                do {
                    let decoder : JSONDecoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let objList = try decoder.decode([Receipt].self, from: response.data!)
       //             print ("Receipts: \(String(describing:objList))")
                    
                    let realm = try! Realm()
                    try! realm.write {
                        realm.add(objList, update: true)
                    }
                    
                } catch DecodingError.dataCorrupted(let context) {
                    print(context)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.valueNotFound(let value, let context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.typeMismatch(let type, let context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
                
            }
            else  {
                print("error calling GET on \(resourceURL)")
                print(response.error!)
                
            }
        }
    }
  
}
