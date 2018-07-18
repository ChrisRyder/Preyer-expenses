//
//  CostCenter.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 28.06.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation

class Partner : Comparable , CustomStringConvertible {
    var description: String { return "\(name)" }
    
    let id : Int // 2,
    var par : String? //"214",
    let name : String // "Kermit the Frog",
    var payor : Bool? // false,
    var client : Bool? //false,
    var costCenter : Bool? //true
    var hidden : Bool?
    
    init( id : Int ,par : String , name : String ,payor : Bool , client : Bool ,  costCenter : Bool ) {
        self.id = id
        self.par = par
        self.name = name
        self.payor = payor
        self.client = client
        self.costCenter = costCenter
        
    }
  
    static func < (lhs: Partner, rhs: Partner) -> Bool {
        return lhs.name < rhs.name
    }
    static func == (lhs: Partner, rhs: Partner) -> Bool {
        return lhs.name == rhs.name
    }
    
}
