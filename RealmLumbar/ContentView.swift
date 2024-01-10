//
//  ContentView.swift
//  RealmLumbar
//
//  Created by Warren Hansen on 1/9/24.
//

import SwiftUI
import RealmSwift

struct ContentView: View {

    @ObservedResults(LumbarList.self) var lumbarList
    
    var body: some View {
        NavigationView {
            
            VStack {
                if lumbarList.isEmpty {
                    Text("Lumbar List is Empty")
                }
                List {
                    ForEach(lumbarList, id: \.id) { lumbar in
                        LumbarRow(id: lumbar.id)
                    }
                }.navigationTitle("RJB SF")
                Button("CLEAR ALL") {
                    deleteRealm()
                    generateLumbatListDefaults()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        newLumbarObject()
                    } label: {
                        Image(systemName: "plus")
                    }
                    
                }
            }.onAppear() {
                if lumbarList.isEmpty {
                        generateLumbatListDefaults()
                }
            }
            
        }
    }
    
    func generateLumbatListDefaults()  {
        let retrievedObject = LumbarList()
        retrievedObject.title = "L 1"
        retrievedObject.axial = 5.0
        retrievedObject.sagital = 10.0
        $lumbarList.append(retrievedObject)
        
        let retrievedObject2 = LumbarList()
        retrievedObject2.title = "L 2"
        retrievedObject2.axial = 20.0
        retrievedObject2.sagital = 25.0
        $lumbarList.append(retrievedObject2)
    }
    
    func newLumbarObject()  {
        let num = lumbarList.count + 1
        let retrievedObject = LumbarList()
        retrievedObject.title = "L \(num)"
        retrievedObject.axial = 10.0
        retrievedObject.sagital = 10.0
        $lumbarList.append(retrievedObject)
        
    }
    
    private func deleteRealm() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        //generateLumbatListDefaults()
    }
}

#Preview {
    ContentView()
}
