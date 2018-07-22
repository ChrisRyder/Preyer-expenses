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
    
    
    convenience init(from json: JSON) {
        self.init()
        self.id = json["id"].int!
        self.trDay = (json["trDay"].null == NSNull()) ? String() : json["trDay"].string!
        self.fromTime = (json["fromTime"].null == NSNull()) ? nil : json["fromTime"].date!
        self.toTime = (json["toTime"].null == NSNull()) ? nil : json["toTime"].date!
        self.reason = (json["reason"].null == NSNull()) ? String() : json["reason"].string!
        self.infoText = (json["infoText"].null == NSNull()) ? String() : json["infoText"].string!
        self.interruptA = (json["interruptA"].null == NSNull()) ? false : json["interruptA"].bool!
        self.breakfast = (json["breakfast"].null == NSNull()) ? false : json["breakfast"].bool!
        self.lunch = (json["lunch"].null == NSNull()) ? false : json["lunch"].bool!
        self.dinner = (json["dinner"].null == NSNull()) ? false : json["dinner"].bool!
 
        self.accommodation = (json["accommodation"].null == NSNull()) ? nil : Accomodation(from: json["accommodation"])
  
        self.food = (json["food"].null == NSNull()) ? nil: Food(from: json["food"])
    }
  
}
