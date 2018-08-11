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
    
    private enum CodingKeys: String, CodingKey {
        case id, route, rentalCar,train,airplane,kmTraveler,noPaying,vehicle
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(route, forKey: .route)
        try container.encode(rentalCar, forKey: .rentalCar)
        try container.encode(train, forKey: .train)
        try container.encode(airplane, forKey: .airplane)
        try container.encode(kmTraveler, forKey: .kmTraveler)
        try container.encode(noPaying, forKey: .noPaying)
        try container.encode(vehicle, forKey: .vehicle)
        
    }
    
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        route = try container.decode(String.self, forKey: .route)
        rentalCar = try container.decode(Bool.self, forKey: .rentalCar)
        train = try container.decode(Bool.self, forKey: .train)
        airplane = try container.decode(Bool.self, forKey: .airplane)
        kmTraveler = try container.decode(Int.self, forKey: .kmTraveler)
        noPaying = try container.decode(Bool.self, forKey: .noPaying)
        vehicle = try container.decode(Vehicle?.self, forKey: .vehicle)
        
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
