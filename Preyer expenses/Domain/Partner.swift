//
//  CostCenter.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 28.06.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Partner : Object , Uploadable {
    //var description: String { return "\(name)" }
    
    @objc dynamic var id : Int = 0
    @objc dynamic var par : String = String()
    @objc dynamic var name : String = String()
    @objc dynamic var payor : Bool = false
    @objc dynamic var client : Bool = false
    @objc dynamic var costCenter : Bool = false
    @objc dynamic var hidden : Bool = false
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var resourceURL: URL {
        return URL(string: "\(BASE_APP_URL)/api/partners")!
    }
    private enum CodingKeys: String, CodingKey {
        case id, par, name,payor,client,costCenter,hidden
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
   do {
    id = try container.decode(Int.self, forKey: .id)

        par = try container.decode(String.self, forKey: .par)
  
        name = try container.decode(String.self, forKey: .name)
        
        let booltypes = ["TRUE","1"]
        
        if let payorBool = try? container.decode(Bool.self, forKey: .payor) {
            payor = payorBool
        } else {
            
            let payorString = try container.decode(String.self, forKey: .payor)
            print("String: \(payorString)")
            payor = booltypes.contains(payorString.uppercased())
        }
 
        if let clientBool = try? container.decode(Bool.self, forKey: .client) {
            client = clientBool
        } else {
            let clientString = try container.decode(String.self, forKey: .client)
            client = booltypes.contains(clientString.uppercased())
        }
        
        if let costCenterBool = try? container.decode(Bool.self, forKey: .costCenter) {
            costCenter = costCenterBool
        } else {
            let costCenterString = try container.decode(String.self, forKey: .costCenter)
            costCenter = booltypes.contains(costCenterString.uppercased())
            
        }
        
        if let hiddenBool = try? container.decode(Bool.self, forKey: .hidden) {
            hidden = hiddenBool
        } else {
            let hiddenString = try container.decode(String.self, forKey: .hidden)
            hidden = booltypes.contains(hiddenString.uppercased())
        }
        
  } catch let jsonErr {
    print("Error: ", jsonErr)
        }

    }
    
    
    
}
