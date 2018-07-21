//
//  TravelDays.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 28.06.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
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
}
