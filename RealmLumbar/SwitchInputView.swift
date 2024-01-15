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
        let uuid1 = inputList[0].singlePeripheralUUID
        let uuid2 = inputList[1].singlePeripheralUUID
        let uuid3 = inputList[2].singlePeripheralUUID
        let uuid4 = inputList[3].singlePeripheralUUID
        return [uuid1, uuid2, uuid3, uuid4]
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
            .onChange(of: selectedSegment) { newIndex in
                let stringID = connectedDevices[newIndex]
                switchSelectedInputFrom(stringID: stringID)
                
            }
            
            Text("Selected UUID: \(connectedDevices[selectedSegment])")
                .padding()
        }
    }
    
    func switchSelectedInputFrom(stringID: String) {
        let itemSelected = InputList.getObject(id: stringID)
        InputList.updateSelectedUUID(item: itemSelected, isSelected: true)
    }
}
#Preview {
    SegmentedSwitchView()
}
