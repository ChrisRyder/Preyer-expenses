//
//  TravelDays.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 28.06.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
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
    var accommodation : Accomodation?
    var trip = LinkingObjects(fromType: Trip.self, property: "travelDays")
    var food : Food?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var resourceURL: URL {
        return URL(string: "\(BASE_APP_URL)/api/traveldays")!
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, trDay, fromTime,toTime,reason,infoText,interruptA,breakfast,lunch,dinner,accommodation,food
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
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
         try container.encode(accommodation, forKey: .accommodation)
        try container.encode(food, forKey: .food)
    }
    
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        trDay = try container.decode(String.self, forKey: .trDay)
        fromTime = try container.decode(Date.self, forKey: .fromTime)
        toTime = try container.decode(Date.self, forKey: .toTime)
        infoText = try container.decode(String.self, forKey: .infoText)
        reason = try container.decode(String.self, forKey: .reason)
        interruptA = try container.decode(Bool.self, forKey: .interruptA)
        breakfast = try container.decode(Bool.self, forKey: .breakfast)
        lunch = try container.decode(Bool.self, forKey: .lunch)
        dinner = try container.decode(Bool.self, forKey: .dinner)
        accommodation = try container.decode(Accomodation?.self, forKey: .accommodation)
        food = try container.decode(Food?.self, forKey: .food)
    }
   
  
}
