//
//  SyncService.sqift.swift
//  Preyer expenses
//
//  Created by Chris Ryder on 01.08.18.
//  Copyright © 2018 Preyer GmbH. All rights reserved.
//

import Foundation
import RealmSwift


class SyncService {
    
    private let realm: Realm
    private let tokens: [NotificationToken]
    
    init(modelTypes: [Syncable.Type], realm: Realm = try! Realm()) {
        self.realm = realm
        
        tokens = modelTypes.map { modelType in
            modelType.registerNotificationObserver(for: realm, callback: SyncService.handleUpdate)
        }
    }

    private static func handleUpdate(_ update: Update) {
        update.insertions.forEach { upload($0, isUpdated: false) }
        update.modifications.forEach { upload($0, isUpdated: true) }
        update.deletedIds.forEach { deleteObject(withId: $0, ofType: update.type) }
    }
    
    private static func upload(_ object: Syncable, isUpdated: Bool) {
        let url: URL
        let httpMethod: String
        
        if isUpdated {
            url = type(of: object).resourceURL.appendingPathComponent("/\(object.getId())")
            httpMethod = "PUT"
        } else {
            url = type(of: object).resourceURL
            httpMethod = "POST"
        }
        
        performRequest(method: httpMethod, url: url, data: object.encoded())
    }
    
    private static func deleteObject(withId id: String, ofType type: Syncable.Type) {
        let url = type.resourceURL.appendingPathComponent("/\(id)")
        performRequest(method: "DELETE", url: url)
    }
    
    private static func performRequest(method: String, url: URL, data: Data? = nil) {
        if let data = data {
            let json = String(decoding: data, as: UTF8.self)
            print("\(method): \(url.path)\n\(json)")
        } else {
            print("\(method): \(url.path)")
        }
    }

}
