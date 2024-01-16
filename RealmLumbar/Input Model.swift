//
//  Input Model.swift
//  RealmLumbar
//
//  Created by Warren Hansen on 1/12/24.
//

import RealmSwift
import SwiftUI

class InputList: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var singlePeripheralUUID: String
    @Persisted var isSelectd: Bool
    
    override class func primaryKey() -> String? {
        "id"
    }
    
    static func displaySelectedInput() -> String {
        //print("inside displaySelectedInput")
        let selection = InputList.getSelectedItem()
        let uuidName = selection.first?.singlePeripheralUUID
        //print("\ngot selected item from model: \(uuidName)")
        return  uuidName ?? "No Device"
    }
    
    static func updateSelectedUUID(item: InputList, isSelected: Bool) {
        do {
            let realm = try Realm()
            
            if let inputToChange = realm.object(ofType: InputList.self, forPrimaryKey: item.id) {
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
                print("error getting \(id)")
                return retrievedObject
            }
            //print("in func got this object back \(retrievedObject.singlePeripheralUUID)")
            retrievedObject = objectFiltered
        }
        catch {
            print(error)
        }
        return retrievedObject
    }
    
    static func getObjectWith(uuid: String) -> Results<InputList>  {
        var items: Results<InputList> {
            let realm = try! Realm()
            return realm.objects(InputList.self).filter("singlePeripheralUUID == %@", uuid)
        }
        return items
    }
    
    static func updateItemPerifUUID(item: InputList, newUUID: String) {
        //print("in ")
        do {
            let realm = try Realm()
            
            if let inputToChange = realm.object(ofType: InputList.self, forPrimaryKey: item.id) {
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
            //defaultObject._id = "Device 1"
            defaultObject.singlePeripheralUUID = "Device 1"
            defaultObject.isSelectd = true
            return defaultObject
        case 2:
            let defaultObject2 = InputList()
            //defaultObject2._id = "Device 2"
            defaultObject2.singlePeripheralUUID = "Device 2"
            defaultObject2.isSelectd = false
            return defaultObject2
        case 3:
            let defaultObject3 = InputList()
            //defaultObject3._id = "Device 3"
            defaultObject3.singlePeripheralUUID = "Device 3"
            defaultObject3.isSelectd = false
            return defaultObject3
        case 4:
            let defaultObject4 = InputList()
            //defaultObject4._id = "Device 4"
            defaultObject4.singlePeripheralUUID = "Device 4"
            defaultObject4.isSelectd = false
            return defaultObject4
        default:
            let defaultObject = InputList()
            //defaultObject._id = "Device 1"
            defaultObject.singlePeripheralUUID = "Device 1"
            defaultObject.isSelectd = true
            return defaultObject
        }
    }
    
    func replaceUUID() {
        
    }
}
