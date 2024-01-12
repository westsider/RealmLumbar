//
//  Models.swift
//  RealmLumbar
//
//  Created by Warren Hansen on 1/9/24.
//

import Foundation
import RealmSwift
import UIKit
import SwiftUI

// geneate a lumbar item

class LumbarList: Object, Identifiable {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var axial: Double
    @Persisted var sagital: Double
    @Persisted var leftSelected: Bool
    @Persisted var isSelected: Bool
    
    override class func primaryKey() -> String? {
        "id"
    }
    
    static func getSelected(itemId: ObjectId) {
        do {
            let realm = try Realm()
            guard let item = realm.object(ofType: LumbarList.self, forPrimaryKey: itemId) else {return  }
            
            print("Realm retrieved Selected Item: ID: \(item.id), AX: \(item.axial), SG: \(item.sagital)")
        } catch {
            print(error)
        }
    }
    
    
    static func updateItemAsSelected(item: LumbarList) {
        do {
            let realm = try Realm()
            
            if let lumbarToSelect = realm.object(ofType: LumbarList.self, forPrimaryKey: item.id) {
                try realm.write {
                    lumbarToSelect.isSelected = true
                }
                print("item updated to isSelected")
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
            
            //if let lumbarToSelect = realm.object(ofType: LumbarList.self, forPrimaryKey: item.id) {
            try realm.write {
                itemToDeSelect.isSelected = false
            }
            print("item updated to isSelected")
            // }
        } catch {
            print("An error occurred while updating the LumbarList: \(error)")
        }
    }
    
    static func getSelectedItem() -> Results<LumbarList> {
        var item: Results<LumbarList> {
            let realm = try! Realm()
            return realm.objects(LumbarList.self).filter("isSelected == %@", true)
        }
        
        print("Realm found Selected Item: ID: \(item.first?.id), AX: \(item.first?.axial), SG: \(item.first?.sagital)")
        
        return item
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
