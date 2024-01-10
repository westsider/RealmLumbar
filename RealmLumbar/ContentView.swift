//
//  ContentView.swift
//  RealmLumbar
//
//  Created by Warren Hansen on 1/9/24.

//  Add left right
//  selected row is colored
//  add a crosshair struct to set how its updated

//  how do I pass selected row to crosshair? can I send the id?
//  how do I pass in hold and offset?

//  future
//  how do I know what data stream is selected? need a var for selectedUUID
//  how do I set hold or offset? need a var somewhere for offsetOn, hold on


import SwiftUI
import RealmSwift

struct ContentView: View {
    
    @ObservedResults(LumbarList.self) var lumbarList
    
    var body: some View {
        NavigationView {
            
            VStack {
                HStack {
                    Spacer(minLength: 100)
                    Text(" ")
                    Spacer()
                    Text("AX").bold()
                    Spacer()
                    Text("SG").foregroundStyle(.gray)
                    Spacer()
                }.offset(x: -30, y: 0)
                VStack {
                    if lumbarList.isEmpty {
                        Text("Lumbar List is Empty")
                    }
                    List {
                        ForEach(lumbarList, id: \.id) { lumbar in
                            LumbarRow(id: lumbar.id)
                        }
                    }
                    .scrollContentBackground(.hidden).padding(.top, -25)
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
    }
    
    func generateLumbatListDefaults()  {
        let retrievedObject = LumbarList()
        retrievedObject.title = "L1"
        retrievedObject.axial = 5.0
        retrievedObject.sagital = 10.0
        $lumbarList.append(retrievedObject)
        
        let retrievedObject2 = LumbarList()
        retrievedObject2.title = "L2"
        retrievedObject2.axial = 20.0
        retrievedObject2.sagital = 25.0
        $lumbarList.append(retrievedObject2)
    }
    
    func newLumbarObject()  {
        let num = lumbarList.count + 1
        let retrievedObject = LumbarList()
        retrievedObject.title = "L\(num)"
        retrievedObject.axial = 10.0
        retrievedObject.sagital = 10.0
        $lumbarList.append(retrievedObject)
        
    }
    
    private func deleteRealm() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
}

#Preview {
    ContentView()
}
