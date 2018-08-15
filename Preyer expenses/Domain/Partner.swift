//
//  CostCenter.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 28.06.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class Partner : Object , Uploadable {
    //var description: String { return "\(name)" }
    
    @objc dynamic var id : Int = 0
    @objc dynamic var par : String = String()
    @objc dynamic var name : String = String()
    @objc dynamic var payor : Bool = false
    @objc dynamic var client : Bool = false
    @objc dynamic var costCenter : Bool = false
    @objc dynamic var hidden : Bool = false
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var resourceURL: URL {
        return URL(string: "\(BASE_APP_URL)/api/partners")!
    }
    private enum CodingKeys: String, CodingKey {
        case id, par, name,payor,client,costCenter,hidden
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        par = try container.decode(String.self, forKey: .par)
        name = try container.decode(String.self, forKey: .name)
        payor = try container.decodeIfPresent(Bool.self, forKey: .payor) ?? false
        client = try container.decodeIfPresent(Bool.self, forKey: .client) ?? false
        costCenter = try container.decodeIfPresent(Bool.self, forKey: .costCenter) ?? false
        hidden = try container.decodeIfPresent(Bool.self, forKey: .hidden) ?? false
    
        


    }
    
    static func getList() {
        
        sessionManager.request(resourceURL).responseJSON { (response: DataResponse<Any>) in
            print("======== get Partners() ===========")
            print("Request: \(String(describing: response.request))")   // original url request
 //           print("Response: \(String(describing: response))") // http url response
            
            print("error: \(String(describing: response.error))")
          //  print("value: \(String(describing: response.value))")
            
            if response.error == nil {
                print("Result: \(String(describing: response.result))")  // response serialization result
                
                do {
                    let objList = try JSONDecoder().decode([Partner].self, from: response.data!)
                    //print ("partners: \(String(describing:objList))")
                    
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
