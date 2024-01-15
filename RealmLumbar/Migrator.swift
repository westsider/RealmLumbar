//
//  Migrator.swift
//  RealmLumbar
//
//  Created by Warren Hansen on 1/11/24.
//

import Foundation
import RealmSwift

class Migrator {
    
    init() {
        //updateSchema()
        deleteAndReInit()
    }
    
    func deleteAndReInit() {
        let config = Realm.Configuration.defaultConfiguration
        do {
            if let fileURL = config.fileURL {
                try FileManager.default.removeItem(at: fileURL)
            }
            let newRealm = try Realm(configuration: config)
            // Now 'newRealm' is a fresh instance of Realm with no data
            // You can start using it for your application
        } catch {
            print("Error deleting and reinitializing Realm database: \(error)")
        }
    }
    
    func updateSchema() {
        
        // when running a new migration this top "1" number must be the same as
        // the new 'if oldSchemaVersion < 1 {'
        // make sure the class type is correct and the new value type
        let config = Realm.Configuration(schemaVersion: 2) { migration, oldSchemaVersion in
            
            if oldSchemaVersion < 1 {
                // add new fields
                migration.enumerateObjects(ofType: LumbarList.className()) { _, newObject in
                    newObject!["isSelected"] = false
                }
            }
            
            if oldSchemaVersion < 2 {
                migration.enumerateObjects(ofType: InputList.className()) { _, newObject in
                    newObject!["singlePeripheralUUID"] = ""
                    newObject!["isSelectd"] = false
                }
            }
            
        }
        
        Realm.Configuration.defaultConfiguration = config
        let _ = try! Realm()
        
    }
    
}
