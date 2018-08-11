//
//  Reduction.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 21.07.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Reduction: Object, Uploadable {
    @objc dynamic var id : Int = 0
    @objc dynamic var rdnDate : Date?
    @objc dynamic var breakfast : Bool = false
    @objc dynamic var lunch : Bool = false
    @objc dynamic var dinner : Bool = false
    var receipt : Receipt?
    var reductionType : ReductionType?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var resourceURL: URL {
        return URL(string: "\(BASE_APP_URL)/api/reductions")!
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, rdnDate, breakfast,lunch,dinner,receipt,reductionType
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(rdnDate, forKey: .rdnDate)
        try container.encode(breakfast, forKey: .breakfast)
        try container.encode(lunch, forKey: .lunch)
        try container.encode(dinner, forKey: .dinner)
        try container.encode(receipt, forKey: .receipt)
        try container.encode(reductionType, forKey: .reductionType)
    }
    
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        rdnDate = try container.decode(Date.self, forKey: .rdnDate)
         breakfast = try container.decode(Bool.self, forKey: .breakfast)
        lunch = try container.decode(Bool.self, forKey: .lunch)
        dinner = try container.decode(Bool.self, forKey: .dinner)
        receipt = try container.decode(Receipt?.self, forKey: .receipt)
        reductionType = try container.decode(ReductionType?.self, forKey: .reductionType)
    }
    
    
   
}
    

