//
//  ContentView.swift
//  RealmLumbar
//
//  Created by Warren Hansen on 1/9/24.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    
    @ObservedResults(ShoppingList.self) var shoppingLists
    @State private var isPresented: Bool = false
    
    
    var body: some View {
        NavigationView {
            
            VStack {
                if shoppingLists.isEmpty {
                    Text("Shopping List is Empty")
                }
                Button("Delete Realm") {
                    deleteRealm()
                }
                List {
                    ForEach(shoppingLists, id: \.id) { shoppingList in
//                        VStack(alignment: .leading) {
//                            Text(shoppingList.title)
//                            Text(shoppingList.address)
//                                .opacity(0.4)
//                        }
                        LumbarRow(id: shoppingList.id)
                        
                    }
                }.navigationTitle("Grocery App")
            }
            .sheet(isPresented: $isPresented, content: {
                AddShoppingListScreen()
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // action
                        isPresented = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    
                }
            }.onAppear() {
                if shoppingLists.isEmpty {
                        generateDefaultObjecs()
                }
            }
            
        }
    }
    
    func generateDefaultObjecs()  {
        let retrievedObject = ShoppingList()
        retrievedObject.title = "Gen 1"
        retrievedObject.address = "123 lax blvd"
        $shoppingLists.append(retrievedObject)
        
        let retrievedObject2 = ShoppingList()
        retrievedObject2.title = "Gen 2"
        retrievedObject2.address = "911 n mill st"
        $shoppingLists.append(retrievedObject2)
    }
    
    private func showItems() {
//        ForEach(shoppingLists, id: \.id) { shoppingList in
//            Text(shoppingList.title)
//            Text(shoppingList.id)
//        }
//        ForEach(shoppingLists) { list in
//            print(list.id)
//        }
    }
    
    private func deleteRealm() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        generateDefaultObjecs()
    }
}

#Preview {
    ContentView()
}
