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
        return getObject(funcId: id)
    }
    
    // textfeild vars
    @State private var lumabeName: String = ""
    @State private var axial: String = ""
    @State private var saggital: String = ""
    @FocusState private var focusI: Bool
    @FocusState private var focusS: Bool
    @FocusState private var focusA: Bool
    
    // selection
    //@State private var isSelected : Bool = false
    
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
                            //isSelected = true
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
            let object = getObject(funcId: id)
            try realm.write {
                object.title = lumabeName
                object.axial = Utilities.getDoubleFrom(string: axial)
                object.sagital = Utilities.getDoubleFrom(string: saggital)
                //object.isSelected = isSelected
            }
        }
        catch {
            print(error)
        }
    }
    
    private func getObject(funcId: ObjectId) -> LumbarList {
        return LumbarList.getObject(id: funcId)
    }
}

#Preview {
    LumbarRow(id: ObjectId())
}
