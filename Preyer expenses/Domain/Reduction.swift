//
//  Reduction.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 21.07.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class Reduction: Object, Uploadable {
    @objc dynamic var id : Int = 0
    @objc dynamic var rdnDate : Date?
    @objc dynamic var breakfast : Bool = false
    @objc dynamic var lunch : Bool = false
    @objc dynamic var dinner : Bool = false
    @objc dynamic var receipt : Int = 0
    @objc dynamic var reductionType : Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var resourceURL: URL {
        return URL(string: "\(BASE_APP_URL)/api/reductions")!
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, rdnDate, breakfast,lunch,dinner,receipt,reductionType
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let referObj = Refer()
       try container.encode(id, forKey: .id)
        try container.encode(rdnDate, forKey: .rdnDate)
        try container.encode(breakfast, forKey: .breakfast)
        try container.encode(lunch, forKey: .lunch)
        try container.encode(dinner, forKey: .dinner)
        referObj.id = self.receipt
        try container.encode(referObj, forKey: .receipt)
        referObj.id = self.reductionType
        try container.encode(referObj, forKey: .reductionType)
    }
    
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        rdnDate = try container.decode(Date.self, forKey: .rdnDate)
         breakfast = try container.decode(Bool.self, forKey: .breakfast)
        lunch = try container.decode(Bool.self, forKey: .lunch)
        dinner = try container.decode(Bool.self, forKey: .dinner)
        let receiptReferObj = try container.decode(Refer.self, forKey: .receipt)
        receipt = receiptReferObj.id
        let reductionTypeReferObj = try container.decode(Refer.self, forKey: .reductionType)
        reductionType = reductionTypeReferObj.id

       
    }
    
    static func getList() {
        
        sessionManager.request(resourceURL).responseJSON { (response: DataResponse<Any>) in
            print("======== Reduction.getList() ===========")
            print("Request: \(String(describing: response.request))")   // original url request
            
            print("Response: \(String(describing: response))") // http url response
            print("error: \(String(describing: response.error))")
            print("value: \(String(describing: response.value))")
            
            if response.error == nil {
                print("Result: \(String(describing: response.result))")  // response serialization result
                
                do {
                    let objList = try JSONDecoder().decode([Reduction].self, from: response.data!)
                    print ("Reductions: \(String(describing:objList))")
                    
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
    

