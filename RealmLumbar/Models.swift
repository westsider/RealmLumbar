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
