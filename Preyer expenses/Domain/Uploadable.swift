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

protocol Uploadable: Codable {
    static var resourceURL: URL { get }
}

typealias Syncable = Object & Uploadable

struct Update {
    let insertions: [Syncable]
    let modifications: [Syncable]
    let deletedIds: [String]
    let type: Syncable.Type
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
    
    func encoded(using jsonEncoder: JSONEncoder = JSONEncoder()) -> Data? {
        return try? jsonEncoder.encode(self)
    }
    

    static func registerNotificationObserver(for realm: Realm, callback: @escaping (Update) -> Void) -> NotificationToken {
        let objects = realm.objects(self)
        var objectIds: [String]!
        
        return objects.observe { changes in
            switch changes {
            case .initial(_):
                objectIds = objects.map { $0.getId() }
            case .update(let collection, let deletions, let insertions, let modifications):
                let insertedObjects = insertions.map { collection[$0] }
                let modifiedObjects = modifications.map { collection[$0] }
                let deletedIds = deletions.map { objectIds[$0] }
                
                let update = Update(insertions: insertedObjects, modifications: modifiedObjects, deletedIds: deletedIds, type: Self.self)
                callback(update)
                
                objectIds = objects.map { $0.getId() }
            case .error(_):
                break
            }
        }

    }
}
