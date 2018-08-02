//
//  User.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 28.06.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class User : Object , Uploadable{
    @objc dynamic var  id : Int = 0
    @objc dynamic var  username : String = String()
    @objc dynamic var  password : String = String()
    var  client : Partner?
    @objc dynamic var  email : String = String()
    @objc dynamic var  firstName : String = String()
    @objc dynamic var  lastName : String = String()
    @objc dynamic var  personNumber : String = String()
    var  costCenter : Partner?
    @objc dynamic var  token : String = String()
    var  trips = List<Trip>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var resourceURL: URL {
        return URL(string: "\(BASE_APP_URL)/api/users")!
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, username, password,client,email,firstName,lastName,personNumber,token,trips    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(username, forKey: .username)
        try container.encode(password, forKey: .password)
        try container.encode(client, forKey: .client)
        try container.encode(email, forKey: .email)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(personNumber, forKey: .personNumber)
        try container.encode(token, forKey: .token)
        let tripsArray = Array(self.trips)
        try container.encode(tripsArray, forKey: .trips)
        
    }
    
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        password = try container.decode(String.self, forKey: .password)
        client = try container.decode(Partner?.self, forKey: .client)
        email = try container.decode(String.self, forKey: .email)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        personNumber = try container.decode(String.self, forKey: .personNumber)
        token = try container.decode(String.self, forKey: .token)

        if let arr = try container.decodeIfPresent(Array<Trip>.self, forKey: .trips) {
            trips.append(objectsIn: arr)
        }
    }
    
    convenience init(from json: JSON) {
        self.init()
        self.id = json["id"].int!
        self.username =  (json["infoText"].null == NSNull()) ? String() : json["infoText"].string!
        self.password =  (json["infoText"].null == NSNull()) ? String() : json["infoText"].string!
        self.client = (json["client"].null == NSNull()) ? nil : Partner(from: json["client"])
        self.email =  (json["infoText"].null == NSNull()) ? String() : json["infoText"].string!
        self.firstName =  (json["infoText"].null == NSNull()) ? String() : json["infoText"].string!
        self.lastName =  (json["infoText"].null == NSNull()) ? String() : json["infoText"].string!
        self.personNumber =  (json["infoText"].null == NSNull()) ? String() : json["infoText"].string!
        self.costCenter   = (json["costCenter"].null == NSNull()) ? nil : Partner(from: json["costCenter"])
       // self.trips = trips
   
    }
    

}
