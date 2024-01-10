//
//  LumbarRow.swift
//  RealmLumbar
//
//  Created by Warren Hansen on 1/10/24.
//

import SwiftUI
import RealmSwift

struct LumbarRow: View {
    
    var id: ObjectId
    var listObject: ShoppingList {
        return getObject()
    }
    
    // textfeild vars
    @State private var title: String = ""
    @State private var address: String = ""
    @FocusState private var focusI: Bool
    @FocusState private var focusS: Bool
    @FocusState private var focusA: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                TextField("title", text: $title)
                    .focused($focusI)
                    .onChange(of: focusI) { focused in
                        if focused {
                            title = ""
                        } else {
                            // persist name
                            persistObject()
                        }
                    }
                    .onAppear() {
                        title = listObject.title
                    }
                Spacer()
                //Text("\(listObject.address)")
                TextField("address", text: $address)
                    .focused($focusS)
                    .onChange(of: focusS) { focused in
                        if focused {
                            address = ""
                        } else {
                            // persist name
                            persistObject()
                        }
                    }
                    .onAppear() {
                        address = listObject.address
                    }
                Spacer()
            }
        }
    }
    
    private func persistObject() {
        do {
            let realm = try Realm()
            var object = getObject()
            try realm.write {
                object.title = title
                object.address = address
            }
        }
        catch {
            print(error)
        }
    }
    
    private func getObject() -> ShoppingList {
        var retrievedObject = ShoppingList()
        retrievedObject.title = "no title"
        retrievedObject.address = "no address"
        do {
            let realm = try Realm()
            guard let objectFiltered = realm.object(ofType: ShoppingList.self, forPrimaryKey: id) else {
                return retrievedObject
            }
            retrievedObject = objectFiltered
        }
        catch {
            print(error)
        }
        return retrievedObject
    }
}

#Preview {
    LumbarRow(id: ObjectId())
}
