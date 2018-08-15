//
//  CCyRate.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 21.07.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift


class CcyRate: Object ,Uploadable  {
    
    //override var description: String { return "\(String(describing: name)): \(String(describing: rate))" }
    
    @objc dynamic var id : Int = 0
    @objc dynamic var cur1 : Int = 0
    @objc dynamic var cur2 : Int = 0
    @objc dynamic var rate : Float = 0.0
    @objc dynamic var name : String = String()
    @objc dynamic var comment : String = String()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var resourceURL: URL {
        return URL(string: "\(BASE_APP_URL)/api/CcyRates")!
    }

  
    
    private enum CodingKeys: String, CodingKey {
        case id, cur1, cur2,rate,name,comment  }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let referObj = Refer()
        
        try container.encode(id, forKey: .id)
        referObj.id = self.cur1
        try container.encode(referObj, forKey: .cur1)
       
        referObj.id = self.cur2
        try container.encode(referObj, forKey: .cur2)
       
        try container.encode(rate, forKey: .rate)
        try container.encode(name, forKey: .name)
        try container.encode(comment, forKey: .comment)
        
        
    }
    
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        let cur1ReferObj = try container.decode(Refer.self, forKey: .cur1)
        cur1 = cur1ReferObj.id
        let cur2ReferObj = try container.decode(Refer.self, forKey: .cur2)
        cur2 = cur2ReferObj.id

        rate = try container.decode(Float.self, forKey: .rate)
        name = try container.decode(String.self, forKey: .name)
        comment = try container.decode(String.self, forKey: .comment)
        
    }
    
    
    static func getList() {
        
        sessionManager.request(resourceURL).responseJSON { (response: DataResponse<Any>) in
            print("======== getCcyRates() ===========")
            print("Request: \(String(describing: response.request))")   // original url request
            
            //print("Response: \(String(describing: response))") // http url response
            print("error: \(String(describing: response.error))")
            //print("value: \(String(describing: response.value))")
            
            if response.error == nil {
                print("Result: \(String(describing: response.result))")  // response serialization result
                
                do {
                    let objList = try JSONDecoder().decode([CcyRate].self, from: response.data!)
                    //print ("ccyRates: \(String(describing:objList))")
                    
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

