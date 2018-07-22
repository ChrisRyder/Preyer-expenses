//
//  TravelCost.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 21.07.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class TravelCost: Object , Uploadable{
    @objc dynamic var id : Int = 0
    @objc dynamic var route: String = String()
    @objc dynamic var rentalCar : Bool = false
    @objc dynamic var train: Bool = false
    //    var passenger: Bool
    @objc dynamic var airplane : Bool = false
    //    var ship : Bool
    //    var kmDriversLog : Float
    @objc dynamic var kmTraveler : Int = 0
    //    var kmPassenger : Integer
    //    var indRefund : Float
    @objc dynamic var infoText : String = String()
    @objc dynamic var noPaying : Bool = false
    var vehicle : Vehicle?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var resourceURL: URL {
        return URL(string: "\(BASE_APP_URL)/api/travelcosts")!
    }
    
    convenience init(from json: JSON) {
        self.init()
        self.id = json["id"].int!
        self.route = (json["route"].null == NSNull()) ? String() : json["route"].string!
        self.rentalCar = (json["rentalCar"].null == NSNull()) ? false : json["rentalCar"].bool!
        self.train = (json["train"].null == NSNull()) ? false : json["train"].bool!
        self.airplane = (json["airplane"].null == NSNull()) ? false : json["airplane"].bool!
        self.kmTraveler = (json["kmTraveler"].null == NSNull()) ? 0 : json["kmTraveler"].int!
        self.infoText = (json["infoText"].null == NSNull()) ? String() : json["infoText"].string!
        self.noPaying = (json["noPaying"].null == NSNull()) ? false : json["noPaying"].bool!
        self.vehicle = (json["vehicle"].null == NSNull()) ? nil : Vehicle(from: json["vehicle"])
        
    }

}
