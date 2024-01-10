//
//  Models.swift
//  RealmLumbar
//
//  Created by Warren Hansen on 1/9/24.
//

import Foundation
import RealmSwift

class ShoppingList: Object, Identifiable {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var address: String
    
    @Persisted var items: List<ShoppingItem> = List<ShoppingItem>()
    
    override class func primaryKey() -> String? {
        "id"
    }
    
}

class ShoppingItem: Object, Identifiable {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var quantity: Int
    @Persisted var category: String
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}

// geneate a lumbar item

class LumbarList: Object, Identifiable {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var axial: Double
    @Persisted var sagital: Double
    @Persisted var leftSelected: Bool
    
    override class func primaryKey() -> String? {
        "id"
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
