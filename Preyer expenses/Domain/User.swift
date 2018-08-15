//
//  User.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 28.06.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class User : Object , Uploadable{
    @objc dynamic var  id : Int = 0
    @objc dynamic var  username : String = String()
    @objc dynamic var  password : String = String()
    @objc dynamic var  client : Int = 0
    @objc dynamic var  email : String = String()
    @objc dynamic var  firstName : String = String()
    @objc dynamic var  lastName : String = String()
    @objc dynamic var  personNumber : String = String()
    @objc dynamic var  costCenter : Int = 0
    //@objc dynamic var  token : String = String()
    //var  trips = List<Trip>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var resourceURL: URL {
        return URL(string: "\(BASE_APP_URL)/api/User")!
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, username, password,client,email,firstName,lastName,personNumber,costCenter   }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let referObj = Refer()
        try container.encode(id, forKey: .id)
        try container.encode(username, forKey: .username)
        try container.encode(password, forKey: .password)
        referObj.id = self.client
        try container.encode(referObj, forKey: .client)

        try container.encode(email, forKey: .email)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(personNumber, forKey: .personNumber)
   //     try container.encode(token, forKey: .token)
        referObj.id = self.costCenter
        try container.encode(referObj, forKey: .costCenter)
 
    }
    
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        password = try container.decode(String.self, forKey: .password)
        email = try container.decode(String.self, forKey: .email)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        personNumber = try container.decode(String.self, forKey: .personNumber)
    //    token = try container.decode(String.self, forKey: .token)
        
        let clientReferObj = try container.decode(Refer.self, forKey: .client)
        client = clientReferObj.id

 
        let costCenterReferObj = try container.decode(Refer.self, forKey: .costCenter)
        costCenter = costCenterReferObj.id

    }
    
    static func getList() {
        
        sessionManager.request(resourceURL).responseJSON { (response: DataResponse<Any>) in
            print("======== User.getList() ===========")
            print("Request: \(String(describing: response.request))")   // original url request
            
      //      print("Response: \(String(describing: response))") // http url response
            print("error: \(String(describing: response.error))")
        //    print("value: \(String(describing: response.value))")
            
            if response.error == nil {
                print("Result: \(String(describing: response.result))")  // response serialization result
                
                do {
                    let objList = try JSONDecoder().decode([User].self, from: response.data!)
                 //   print ("Users: \(String(describing:objList))")
                    
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
