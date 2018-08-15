//
//  Vehicle.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 21.07.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class Vehicle : Object , Uploadable {
    @objc dynamic var  id : Int = 0
    @objc dynamic var  vhcl : Int = 0
    @objc dynamic var  name : String = String()
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var resourceURL: URL {
        return URL(string: "\(BASE_APP_URL)/api/vehicles")!
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, vhcl, name }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(vhcl, forKey: .vhcl)
        try container.encode(name, forKey: .name)
        
        
        
    }
    
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        vhcl = try container.decode(Int.self, forKey: .vhcl)
        name = try container.decode(String.self, forKey: .name)
        
        
        
    }

    static func getList() {
        
        sessionManager.request(resourceURL).responseJSON { (response: DataResponse<Any>) in
            print("======== Vehicle.getList() ===========")
            print("Request: \(String(describing: response.request))")   // original url request
            
           // print("Response: \(String(describing: response))") // http url response
            print("error: \(String(describing: response.error))")
            //print("value: \(String(describing: response.value))")
            
            if response.error == nil {
                print("Result: \(String(describing: response.result))")  // response serialization result
                
                do {
                    let objList = try JSONDecoder().decode([Vehicle].self, from: response.data!)
                    //print ("Vehicles: \(String(describing:objList))")
                    
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
