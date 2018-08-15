//
//  TravelDays.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 28.06.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class TravelDay : Object , Uploadable{
    @objc dynamic var id : Int = 0
    @objc dynamic var trDay : String = String()
    @objc dynamic var fromTime : Date?
    @objc dynamic var toTime : Date?
    @objc dynamic var reason : String = String()
    @objc dynamic var infoText : String = String()
    @objc dynamic var interruptA : Bool = false
    @objc dynamic var breakfast : Bool = false
    @objc dynamic var lunch : Bool  = false
    @objc dynamic var dinner : Bool = false
    @objc dynamic var accommodation : Int = 0
    var trip = LinkingObjects(fromType: Trip.self, property: "travelDays")
    @objc dynamic var food : Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var resourceURL: URL {
        return URL(string: "\(BASE_APP_URL)/api/TravelDays")!
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, trDay, fromTime,toTime,reason,infoText,interruptA,breakfast,lunch,dinner,food,accommodation = "accommodations"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let referObj = Refer()
        try container.encode(id, forKey: .id)
        try container.encode(trDay, forKey: .trDay)
        try container.encode(fromTime, forKey: .fromTime)
        try container.encode(toTime, forKey: .toTime)
        try container.encode(infoText, forKey: .infoText)
        try container.encode(reason, forKey: .reason)
        try container.encode(interruptA, forKey: .interruptA)
        try container.encode(breakfast, forKey: .breakfast)
        try container.encode(lunch, forKey: .lunch)
        try container.encode(dinner, forKey: .dinner)
        referObj.id = self.accommodation
        try container.encode(referObj, forKey: .accommodation)
        referObj.id = self.food
        try container.encode(referObj, forKey: .food)
        
    }
    
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        trDay = try container.decodeIfPresent(String.self, forKey: .trDay) ?? ""
        fromTime = try container.decode(Date.self, forKey: .fromTime)
        toTime = try container.decode(Date.self, forKey: .toTime)
        infoText = try container.decodeIfPresent(String.self, forKey: .infoText) ?? ""
        reason = try container.decodeIfPresent(String.self, forKey: .reason) ?? ""
        interruptA = try container.decodeIfPresent(Bool.self, forKey: .interruptA) ?? false
        breakfast = try container.decodeIfPresent(Bool.self, forKey: .breakfast) ?? false
        lunch = try container.decodeIfPresent(Bool.self, forKey: .lunch) ?? false
        dinner = try container.decodeIfPresent(Bool.self, forKey: .dinner) ?? false
        if let accommodationReferObj = try container.decodeIfPresent(Refer.self, forKey: .accommodation) {
            accommodation = accommodationReferObj.id
        }
        if let foodReferObj = try container.decodeIfPresent(Refer.self, forKey: .food) {
            food = foodReferObj.id
        }

    }
    static func getList() {
        
        sessionManager.request(resourceURL).responseJSON { (response: DataResponse<Any>) in
            print("======== TravelDay.getList() ===========")
            print("Request: \(String(describing: response.request))")   // original url request
            
     //       print("Response: \(String(describing: response))") // http url response
            print("error: \(String(describing: response.error))")
      //      print("value: \(String(describing: response.value))")
            
            if response.error == nil {
                print("Result: \(String(describing: response.result))")  // response serialization result
                
                do {
                    let decoder : JSONDecoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let objList = try decoder.decode([TravelDay].self, from: response.data!)
               //      print ("TravelDays: \(String(describing:objList))")
                    
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
