//
//  CostCenter.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 28.06.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import SwiftyJSON

class Partner : Comparable , CustomStringConvertible {
    var description: String { return "\(name)" }
    
    let id : Int // 2,
    var par : String? //"214",
    let name : String // "Kermit the Frog",
    var payor : Bool? // false,
    var client : Bool? //false,
    var costCenter : Bool? //true
    
    init( id : Int ,par : String , name : String ,payor : Bool , client : Bool ,  costCenter : Bool ) {
        self.id = id
        self.par = par
        self.name = name
        self.payor = payor
        self.client = client
        self.costCenter = costCenter
    }
    convenience init(json: JSON) {
        print(json)
        let id: Int =  json["id"].int!
        let par : String = (json["par"].null == NSNull()) ? "" : json["par"].string!
        let name : String = (json["name"].null == NSNull()) ? "" : json["name"].string!
        let payor = (json["payor"].null == NSNull()) ? false : json["payor"].bool!
        let client   = (json["client"].null == NSNull()) ? false : json["client"].bool!
        let costCenter   = (json["costCenter"].null == NSNull()) ? false : json["costCenter"].bool!
        self.init(id : id ,par : par , name : name ,payor : payor , client : client ,  costCenter : costCenter )
        debugPrint(self)
        
    }
    func toJSON() -> Dictionary<String, Any> {
        return [
            "id" : self.id,
            "par" : self.par as Any ,
            "name" : self.name,
            "payor"  : self.payor as Any,
            "client" : self.client as Any,
            "costCenter" : self.costCenter as Any,
        ]
    }
    static func < (lhs: Partner, rhs: Partner) -> Bool {
        return lhs.name < rhs.name
    }
    static func == (lhs: Partner, rhs: Partner) -> Bool {
        return lhs.id == rhs.id
    }
    
}
