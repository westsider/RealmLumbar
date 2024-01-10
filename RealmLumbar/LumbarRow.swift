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
    var listObject: LumbarList {
        return getObject()
    }
    
    // textfeild vars
    @State private var lumabeName: String = ""
    @State private var axial: String = ""
    @State private var saggital: String = ""
    @FocusState private var focusI: Bool
    @FocusState private var focusS: Bool
    @FocusState private var focusA: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                TextField("2 char", text: $lumabeName.max(2))
                    .focused($focusI)
                    .onChange(of: focusI) { focused in
                        if focused {
                            lumabeName = ""
                        } else {
                            // persist name
                            persistObject()
                        }
                    }
                    .onAppear() {
                        lumabeName = listObject.title
                    }
                Spacer()
                //Text("\(listObject.address)")
                TextField("axial", text: $axial)
                    .focused($focusA)
                    .onChange(of: focusA) { focused in
                        if focused {
                            axial = ""
                        } else {
                            // persist name
                            persistObject()
                        }
                    }
                    .onAppear() {
                        axial = "\(listObject.axial)"
                    }.bold()
                Spacer()
                //Text("\(listObject.address)")
                TextField("sagital", text: $saggital)
                    .focused($focusS)
                    .onChange(of: focusS) { focused in
                        if focused {
                            saggital = ""
                        } else {
                            // persist name
                            persistObject()
                        }
                    }
                    .onAppear() {
                        saggital = "\(listObject.sagital)"
                    }.foregroundStyle(.black.opacity(0.5))
                Spacer()
            }
        }
    }
    
    private func persistObject() {
        do {
            let realm = try Realm()
            let object = getObject()
            try realm.write {
                object.title = lumabeName
                object.axial = Utilities.getDoubleFrom(string: axial)
                object.sagital = Utilities.getDoubleFrom(string: saggital)
            }
        }
        catch {
            print(error)
        }
    }
    
    private func getObject() -> LumbarList {
        var retrievedObject = LumbarList()
        retrievedObject.title = "L1"
        retrievedObject.axial = 1.0
        retrievedObject.sagital = 1.0
        retrievedObject.leftSelected = true
        
        do {
            let realm = try Realm()
            guard let objectFiltered = realm.object(ofType: LumbarList.self, forPrimaryKey: id) else {
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

//struct LumbarRow: View {
//    
//    var id: ObjectId
//    var listObject: ShoppingList {
//        return getObject()
//    }
//    
//    // textfeild vars
//    @State private var title: String = ""
//    @State private var address: String = ""
//    @FocusState private var focusI: Bool
//    @FocusState private var focusS: Bool
//    @FocusState private var focusA: Bool
//    
//    var body: some View {
//        VStack {
//            HStack {
//                Spacer()
//                TextField("title", text: $title)
//                    .focused($focusI)
//                    .onChange(of: focusI) { focused in
//                        if focused {
//                            title = ""
//                        } else {
//                            // persist name
//                            persistObject()
//                        }
//                    }
//                    .onAppear() {
//                        title = listObject.title
//                    }
//                Spacer()
//                //Text("\(listObject.address)")
//                TextField("address", text: $address)
//                    .focused($focusS)
//                    .onChange(of: focusS) { focused in
//                        if focused {
//                            address = ""
//                        } else {
//                            // persist name
//                            persistObject()
//                        }
//                    }
//                    .onAppear() {
//                        address = listObject.address
//                    }
//                Spacer()
//            }
//        }
//    }
//    
//    private func persistObject() {
//        do {
//            let realm = try Realm()
//            var object = getObject()
//            try realm.write {
//                object.title = title
//                object.address = address
//            }
//        }
//        catch {
//            print(error)
//        }
//    }
//    
//    private func getObject() -> ShoppingList {
//        var retrievedObject = ShoppingList()
//        retrievedObject.title = "no title"
//        retrievedObject.address = "no address"
//        do {
//            let realm = try Realm()
//            guard let objectFiltered = realm.object(ofType: ShoppingList.self, forPrimaryKey: id) else {
//                return retrievedObject
//            }
//            retrievedObject = objectFiltered
//        }
//        catch {
//            print(error)
//        }
//        return retrievedObject
//    }
//}
//#Preview {
//    LumbarRow2(id: ObjectId())
//}
