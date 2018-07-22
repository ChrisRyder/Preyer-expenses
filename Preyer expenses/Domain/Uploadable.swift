//
//  Uploadable.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 21.07.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

protocol Uploadable {
    static var resourceURL: URL { get }
}

extension Object {

    
    
}

extension Uploadable where Self: Object {
    func getId() -> String {
        guard let primaryKey = type(of: self).primaryKey() else {
            fatalError("Objects can't be managed without a primary key")
        }
        
        guard let id = self.value(forKey: primaryKey) else {
            fatalError("Objects primary key isn't set")
        }
        
        return String(describing: id)
    }
    
    //func encoded(using jsonEncoder : JSONEncoder = JSONEncoder()) -> Data? {
    //    return try? jsonEncoder.encode(self)
   // }
    
    func toJSON() {
        let mirrored_object = Mirror(reflecting: self)
        
        for (index, attr) in mirrored_object.children.enumerated() {
            if let propertyName = attr.label as String? {
                print("Attr \(index): \(propertyName) = \(attr.value)")
            }
        }
    }
    


 
}
