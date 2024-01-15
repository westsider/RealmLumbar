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
    
    // in swiftui how can i delete or re initialze the realm database instead of migrate?
    
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
    
//    static func addUUIDToREalm(foundDevice: String) {
//
//        let realm = try! Realm()
//        try! realm.write {
//            //peripheralUUID.append(foundDevice)
//        }
//    }
//    
//    static func getObject(id: ObjectId) -> LumbarList {
//
//    }
//    static func getSavedUUIDs() {
//        for item in peripheralUUID {
//            print(item)
//        }
//    }
}

//
//class InputList: Object, Identifiable {
//    @Persisted(primaryKey: true) var _id: String
//    @Persisted var peripheralUUID: RealmSwift.List<String>
//    @Persisted var selectedUUID: String
//    
//    override class func primaryKey() -> String? {
//        "id"
//    }
//    
////    static func addUUIDToREalm(foundDevice: String) {
////
////        let realm = try! Realm()
////        try! realm.write {
////            //peripheralUUID.append(foundDevice)
////        }
////    }
////
////    static func getObject(id: ObjectId) -> LumbarList {
////
////    }
////    static func getSavedUUIDs() {
////        for item in peripheralUUID {
////            print(item)
////        }
////    }
//}
