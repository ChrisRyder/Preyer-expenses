//
//  Trip.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 28.06.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import Alamofire
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
        case id, beginning, ending,exports,infoText,reason,upfront,costCenter,country = "countries",payor, receipts, travelDays,user
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let referObj = Refer()
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
        try container.encode(receiptsArray, forKey: .receipts)
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
        infoText = (try container.decodeIfPresent(String.self, forKey: .infoText)) ?? ""
        reason = try container.decode(String.self, forKey: .reason)
     //   upfront = try container.decode(Float.self, forKey: .reason)
 
        let costCenterReferObj = try container.decode(Refer.self, forKey: .costCenter)
       costCenter = costCenterReferObj.id
        
        let countryReferObj = try container.decode(Refer.self, forKey: .country)
        country = countryReferObj.id
        
        let payorReferObj = try container.decode(Refer.self, forKey: .payor)
        payor = payorReferObj.id
        if let arr = try! container.decodeIfPresent(Array<Refer>.self, forKey: .receipts) {
            let ids  = arr.map { $0.id }
            print("receipts: \(String(describing: ids)) ")
            let realm = try! Realm()
             let recs = realm.objects(Receipt.self).filter("id IN %@", ids)
            if (recs.count > 0){
                print("receipts: \(String(describing: ids)) >>>>> \(String(describing: recs))")
                receipts.append(objectsIn: recs)
            }
        }
        if let arr = try! container.decodeIfPresent(Array<Refer>.self, forKey: .travelDays) {
            let ids  = arr.map { $0.id }
            print("TravelDays: \(String(describing: ids)) ")
            let realm = try! Realm()
            let recs = realm.objects(TravelDay.self).filter("id IN %@", ids)
            if (recs.count > 0){
                print("TravelDays: \(String(describing: ids)) >>>>> \(String(describing: recs))")
                travelDays.append(objectsIn: recs)
            }
        }
        let userReferObj = try container.decode(Refer.self, forKey: .user)
        user = userReferObj.id
    }
   
    static func getList() {
        
        sessionManager.request(resourceURL).responseJSON { (response: DataResponse<Any>) in
            print("======== Trip.getList() ===========")
            print("Request: \(String(describing: response.request))")   // original url request
            
   //         print("Response: \(String(describing: response))") // http url response
            print("error: \(String(describing: response.error))")
            //print("value: \(String(describing: response.value))")
            
            if response.error == nil {
                print("Result: \(String(describing: response.result))")  // response serialization result
     
                do {
                    let decoder : JSONDecoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let objList = try decoder.decode([Trip].self, from: response.data!)
                 //   print ("Trips: \(String(describing:objList))")
                    
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
