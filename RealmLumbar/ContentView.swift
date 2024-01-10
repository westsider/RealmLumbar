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
    
    // textfeild vars
    @State private var title: String = ""
    @State private var address: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                if shoppingLists.isEmpty {
                    Text("Shopping List is Empty")
                }
                List {
                    ForEach(shoppingLists, id: \.id) { shoppingList in
                        VStack(alignment: .leading) {
                            Text(shoppingList.title)
                            Text(shoppingList.address)
                                .opacity(0.4)
                        }
                        
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
            }
        }
    }
}

#Preview {
    ContentView()
}
