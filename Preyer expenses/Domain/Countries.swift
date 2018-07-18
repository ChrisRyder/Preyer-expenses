//
//  Countries.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 28.06.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation

class Country : Comparable , CustomStringConvertible  {
    static func < (lhs: Country, rhs: Country) -> Bool {
        return lhs.name < rhs.name
    }
    
    var description: String { return "\(name)" }
    
    static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.name == rhs.name
    }
    
    let id : Int
    var cty : String
    var name : String
    
    init(id: Int, cty : String, name: String) {
        self.id = id
        self.cty = cty
        self.name = name
        
    }
    
}
