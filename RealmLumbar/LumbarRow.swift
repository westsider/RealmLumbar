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
    
    /// persisted object
    var listObject: LumbarList {
        return getObject(funcId: id)
    }
    
    /// textfeild vars
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
                            /// persist name
                            persistObject(funcId: id)
                        }
                    }
                    .onAppear() {
                        lumabeName = listObject.title
                    }
                Spacer()
               
                TextField("axial", text: $axial)
                    .focused($focusA)
                    .onChange(of: focusA) { focused in
                        if focused {
                            axial = ""
                        } else {
                            /// persist axial
                            persistObject(funcId: id)
                        }
                    }
                    .onAppear() {
                        axial = "\(listObject.axial)"
                    }.bold()
                    .keyboardType(.numbersAndPunctuation)
                Spacer()

                TextField("sagital", text: $saggital)
                    .focused($focusS)
                    .onChange(of: focusS) { focused in
                        if focused {
                            saggital = ""
                        } else {
                            /// persist saggital
                            persistObject(funcId: id)
                        }
                    }
                    .onAppear() {
                        saggital = "\(listObject.sagital)"
                    }.foregroundStyle(.black.opacity(0.5))
                    .keyboardType(.numbersAndPunctuation)
                Spacer()
            }
        }
    }
    
    private func persistObject(funcId: ObjectId) {
        LumbarList.persistObject(id: funcId, name: lumabeName, ax: axial, sg: saggital)
    }
    
    private func getObject(funcId: ObjectId) -> LumbarList {
        return LumbarList.getObject(id: funcId)
    }
}

#Preview {
    LumbarRow(id: ObjectId())
}
