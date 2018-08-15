//
//  Accomodation.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 21.07.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class Accomodation : Object, Uploadable {
    @objc dynamic var id : Int = 0
    @objc dynamic var indRefund : Float = 0.0
    @objc dynamic var infoText : String = String()
    @objc dynamic var noPaying : Bool = false
    var settlementType : SettlementType?
    var country : Country?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var resourceURL: URL {
        return URL(string: "\(BASE_APP_URL)/api/Accommodations")!
    }
 
    private enum CodingKeys: String, CodingKey {
        case id, indRefund, infoText,noPaying,settlementType,country  }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(indRefund, forKey: .indRefund)
        try container.encode(infoText, forKey: .infoText)
        try container.encode(noPaying, forKey: .noPaying)
        try container.encode(settlementType, forKey: .settlementType)
        try container.encode(country, forKey: .country)
        
        
    }
    
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        indRefund = try container.decode(Float.self, forKey: .indRefund)
        infoText = try container.decode(String.self, forKey: .infoText)
        noPaying = try container.decode(Bool.self, forKey: .noPaying)
        settlementType = try container.decode(SettlementType?.self, forKey: .settlementType)
        country = try container.decode(Country?.self, forKey: .country)
  
    }
    static func getList() {
        
        sessionManager.request(resourceURL).responseJSON { (response: DataResponse<Any>) in
            print("======== Accomodation.getList() ===========")
            print("Request: \(String(describing: response.request))")   // original url request
            
        //    print("Response: \(String(describing: response))") // http url response
            print("error: \(String(describing: response.error))")
      //      print("value: \(String(describing: response.value))")
            
            if response.error == nil {
                print("Result: \(String(describing: response.result))")  // response serialization result
                
                do {
                    let objList = try JSONDecoder().decode([Accomodation].self, from: response.data!)
         //           print ("Accomodations: \(String(describing:objList))")
                    
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
