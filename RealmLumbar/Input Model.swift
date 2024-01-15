//
//  Input Model.swift
//  RealmLumbar
//
//  Created by Warren Hansen on 1/12/24.
//

import RealmSwift
import SwiftUI

class InputList: Object, Identifiable {
    @Persisted(primaryKey: true) var _id: String
    @Persisted var singlePeripheralUUID: String
    @Persisted var isSelectd: Bool
    
    override class func primaryKey() -> String? {
        "id"
    }
    
    
    
    
    static func updateSelectedUUID(item: InputList, isSelected: Bool) {
        do {
            let realm = try Realm()
            
            if let inputToChange = realm.object(ofType: InputList.self, forPrimaryKey: item._id) {
                try realm.write {
                    inputToChange.isSelectd = isSelected
                }
            }
        } catch {
            print("An error occurred while updating the LumbarList: \(error)")
        }
    }
    
    static func deSelectAllInputs() {
        do {
            let realm = try! Realm()

            // Retrieve all objects of the InputList class
            let inputLists = realm.objects(InputList.self)

            // Open a Realm write transaction
            try! realm.write {
                // Loop through each object and set isSelected to false
                for inputList in inputLists {
                    inputList.isSelectd = false
                }
            }
        } catch {
            print("An error occurred while updating the LumbarList: \(error)")
        }
    }
    
    static func getSelectedItem() -> Results<InputList> {
        var item: Results<InputList> {
            let realm = try! Realm()
            return realm.objects(InputList.self).filter("isSelectd == %@", true)
        }
        //print("Realm found Selected Item: ID: \(item.first?.id), IS SELECTED: \(item.first?.isSelectd), UUID: \(item.first?.singlePeripheralUUID)")
        
        return item
    }
    
    static func getObject(id: String) -> InputList {
        
        var retrievedObject = InputList()
        do {
            let realm = try Realm()
            guard let objectFiltered = realm.object(ofType: InputList.self, forPrimaryKey: id) else {
                return retrievedObject
            }
            retrievedObject = objectFiltered
        }
        catch {
            print(error)
        }
        return retrievedObject
    }
    
    static func updateItemPerifUUID(item: InputList, newUUID: String) {
        do {
            let realm = try Realm()
            
            if let inputToChange = realm.object(ofType: InputList.self, forPrimaryKey: item._id) {
                try realm.write {
                    inputToChange.singlePeripheralUUID = newUUID
                }
            }
        } catch {
            print("An error occurred while updating the LumbarList: \(error)")
        }
    }
    
    static func generateDefaultObject(num: Int) -> InputList {
        
        switch num {
        case 1:
            let defaultObject = InputList()
            defaultObject._id = "Device 1"
            defaultObject.singlePeripheralUUID = "No Device 1"
            defaultObject.isSelectd = true
            return defaultObject
        case 2:
            let defaultObject2 = InputList()
            defaultObject2._id = "Device 2"
            defaultObject2.singlePeripheralUUID = "No Device 2"
            defaultObject2.isSelectd = false
            return defaultObject2
        case 3:
            let defaultObject3 = InputList()
            defaultObject3._id = "Device 3"
            defaultObject3.singlePeripheralUUID = "No Device 3"
            defaultObject3.isSelectd = false
            return defaultObject3
        case 4:
            let defaultObject4 = InputList()
            defaultObject4._id = "Device 4"
            defaultObject4.singlePeripheralUUID = "No Device 4"
            defaultObject4.isSelectd = false
            return defaultObject4
        default:
            let defaultObject = InputList()
            defaultObject._id = "Device 1"
            defaultObject.singlePeripheralUUID = "No Device 1"
            defaultObject.isSelectd = true
            return defaultObject
        }
    }
    
    func replaceUUID() {
        
    }
}
