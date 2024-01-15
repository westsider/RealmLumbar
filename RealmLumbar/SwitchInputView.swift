//
//  SwitchInputView.swift
//  RealmLumbar
//
//  Created by Warren Hansen on 1/12/24.
//

import SwiftUI
import RealmSwift

struct SegmentedSwitchView: View {

    @ObservedResults(InputList.self) var inputList
    
    var connectedDevices: [String] {
        // 1. Fetch the titles from your Realm string array here
        return ["UUID 1", "No Device", "No Device", "No Device"]
    }
    
    // 2. get selected uuid
    // todo - this needs to be a string or send a string to realm
    @State private var selectedSegment = 0
    
    
    // 3. send that back to realm to update the UI
    
    var body: some View {
        VStack {
            Picker("Segmented Switch", selection: $selectedSegment) {
                ForEach(0..<connectedDevices.count) { index in
                    Text(connectedDevices[index])
                        .tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Text("Selected Option: \(connectedDevices[selectedSegment])")
                .padding()
        }
    }
}
#Preview {
    SegmentedSwitchView()
}
