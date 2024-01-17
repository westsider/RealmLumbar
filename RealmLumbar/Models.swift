//
//  Models.swift
//  RealmLumbar
//
//  Created by Warren Hansen on 1/9/24.
//

import RealmSwift
import SwiftUI

class LumbarItems: Object, Identifiable {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var axial: Double
    @Persisted var sagital: Double
    @Persisted var leftSelected: Bool
    @Persisted var isSelected: Bool
    
    override class func primaryKey() -> String? {
        "id"
    }

    static func persistObject(id: ObjectId, name: String, ax: String, sg: String) {
        do {
            let realm = try Realm()
            let object = getObject(id: id)
            try realm.write {
                object.title = name
                object.axial = Utilities.getDoubleFrom(string: ax)
                object.sagital = Utilities.getDoubleFrom(string: sg)
            }
        }
        catch {
            print(error)
        }
    }
    
    static func getObject(id: ObjectId) -> LumbarItems {

        var retrievedObject = LumbarItems()
        retrievedObject.title = "L1"
        retrievedObject.axial = 1.0
        retrievedObject.sagital = 1.0
        retrievedObject.leftSelected = true
        retrievedObject.isSelected = true
        
        do {
            let realm = try Realm()
            guard let objectFiltered = realm.object(ofType: LumbarItems.self, forPrimaryKey: id) else {
                return retrievedObject
            }
            retrievedObject = objectFiltered
        }
        catch {
            print(error)
        }
        return retrievedObject
    }
    
    static func updateItemAsSelected(item: LumbarItems) {
        do {
            let realm = try Realm()
            
            if let lumbarToSelect = realm.object(ofType: LumbarItems.self, forPrimaryKey: item.id) {
                try realm.write {
                    lumbarToSelect.isSelected = true
                }
                //print("item updated to isSelected")
            }
        } catch {
            print("An error occurred while updating the LumbarList: \(error)")
        }
    }
    
    static func removeIsSectedItem() {
        do {
            let realm = try Realm()
            let allSelectedItems = getSelectedItem()
            guard let itemToDeSelect = allSelectedItems.first else { return }
            try realm.write {
                itemToDeSelect.isSelected = false
            }
        } catch {
            print("An error occurred while updating the LumbarList: \(error)")
        }
    }
    
    static func getSelectedItem() -> Results<LumbarItems> {
        var item: Results<LumbarItems> {
            let realm = try! Realm()
            return realm.objects(LumbarItems.self).filter("isSelected == %@", true)
        }
        //  print("Realm found Selected Item: ID: \(item.first?.id), AX: \(item.first?.axial), SG: \(item.first?.sagital)")
        
        return item
    }
    
    static func generateDefaultObject(num: Int) -> LumbarItems {
        
        switch num {
        case 1:
            let retrievedObject = LumbarItems()
            retrievedObject.title = "L1"
            retrievedObject.axial = 5.0
            retrievedObject.sagital = 10.0
            retrievedObject.leftSelected = true
            retrievedObject.isSelected = true
            return retrievedObject
        case 2:
            let retrievedObject2 = LumbarItems()
            retrievedObject2.title = "L2"
            retrievedObject2.axial = 15.0
            retrievedObject2.sagital = 20.0
            retrievedObject2.leftSelected = true
            return retrievedObject2
        case 3:
            let retrievedObject3 = LumbarItems()
            retrievedObject3.title = "L1"
            retrievedObject3.axial = 30.0
            retrievedObject3.sagital = 35.0
            retrievedObject3.leftSelected = false
            return retrievedObject3
        case 4:
            let retrievedObject4 = LumbarItems()
            retrievedObject4.title = "L2"
            retrievedObject4.axial = 40.0
            retrievedObject4.sagital = 45.0
            retrievedObject4.leftSelected = false
            return retrievedObject4
        default:
            let retrievedObject = LumbarItems()
            retrievedObject.title = "L1"
            retrievedObject.axial = 5.0
            retrievedObject.sagital = 10.0
            retrievedObject.leftSelected = true
            retrievedObject.isSelected = true
            return retrievedObject
        }
    }
    
    static func deleteLumbarListRealm() {
        
        let realm = try! Realm()
        // Retrieve all LumbarList objects
        let lumbarListObjects = realm.objects(LumbarItems.self)

        // Perform a batch delete operation
        try! realm.write {
            realm.delete(lumbarListObjects)
        }
    }
    
    static func deleteRealm() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
}





























class Utilities {
    
    static func getDoubleFrom(string: String) -> Double {
        var answer = 0.0
        
        var trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmed.prefix(1) == "+" {
            trimmed = String(trimmed.dropFirst())
        }
        
        
        if let  answer2 = Double(trimmed) {
            // print("got \(string) -> \(answer2)")
            answer = answer2
        }
        
        return answer
    }
    
    static func oneDecimal(fromDouble: Double) -> String {
        
        String(format: "%.01f", fromDouble)
    }
}

extension Binding where Value == Bool {
    // nagative bool binding same as `!Value`
    var not: Binding<Value> {
        Binding<Value> (
            get: { !self.wrappedValue },
            set: { self.wrappedValue = $0}
        )
    }
}

// limit charaters in swiftui textfeild
extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.dropLast())
            }
        }
        return self
    }
}
