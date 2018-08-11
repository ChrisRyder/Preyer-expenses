//
//  Accomodation.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 21.07.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Accomodation : Object, Uploadable {
    @objc dynamic var id : Int = 0
    @objc dynamic var indRefund : Float = 0.0
    @objc dynamic var infoText : String = String()
    @objc dynamic var noPaying : Bool = false
    var settlementType : SettlementType?
    var country : Country?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var resourceURL: URL {
        return URL(string: "\(BASE_APP_URL)/api/accomodation")!
    }
 
    private enum CodingKeys: String, CodingKey {
        case id, indRefund, infoText,noPaying,settlementType,country  }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(indRefund, forKey: .indRefund)
        try container.encode(infoText, forKey: .infoText)
        try container.encode(noPaying, forKey: .noPaying)
        try container.encode(settlementType, forKey: .settlementType)
        try container.encode(country, forKey: .country)
        
        
    }
    
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        indRefund = try container.decode(Float.self, forKey: .indRefund)
        infoText = try container.decode(String.self, forKey: .infoText)
        noPaying = try container.decode(Bool.self, forKey: .noPaying)
        settlementType = try container.decode(SettlementType?.self, forKey: .settlementType)
        country = try container.decode(Country?.self, forKey: .country)
  
    }
  
}
