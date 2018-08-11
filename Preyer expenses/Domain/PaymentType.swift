//
//  PaymentType.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 21.07.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class PaymentType: Object , Uploadable {
    @objc dynamic var id : Int = 0
    @objc dynamic var pmnt : String = String()
    @objc dynamic var name : String = String()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var resourceURL: URL {
        return URL(string: "\(BASE_APP_URL)/api/paymenttypes")!
    }

    private enum CodingKeys: String, CodingKey {
        case id, pmnt, name }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(pmnt, forKey: .pmnt)
        try container.encode(name, forKey: .name)
        
        
        
    }
    
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        pmnt = try container.decode(String.self, forKey: .pmnt)
        name = try container.decode(String.self, forKey: .name)

        
        
    }
    
}
