//
//  HighlightRow.swift
//  RealmLumbar
//
//  Created by Warren Hansen on 1/11/24.
//

import SwiftUI
import RealmSwift

struct HighlightRow: View {
    
    @ObservedResults(LumbarList.self) var lumbarList
    @State private var selectedType: LumbarList?
    
    var body: some View {
        List{
            ForEach(lumbarList, id: \.id){ type in
                Text("\(type.id)")
                    .contentShape(Rectangle()) //makes whole row tappable
                    .onTapGesture {
                        selectedType = type
                    }
                    .listRowBackground(selectedType == type ? Color(.systemFill) : Color(.systemBackground))
            }//ForEach
        }//List
    }
}

#Preview {
    HighlightRow()
}
