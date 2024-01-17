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

    @State private var selectedInput: InputList = InputList()
    
    @State private var selectedDeviceUUID: String = "No Device"
    
    var body: some View {
        if inputList.isEmpty {
            Text("No Inputs")
            
        }
        VStack {
            Picker("Segmented Switch", selection: $selectedInput) {
                ForEach(inputList) { index in
                    Text("\(index.singlePeripheralUUID)")
                        .tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .onChange(of: selectedInput) { newIndex in
                selectNewInputInModel()
                displaySelectedInput()
            }
        }.onAppear() {
            if inputList.isEmpty {
                generateInputListDefaults()
            }
            displaySelectedInput()
        }
    }
    
    func displaySelectedInput() {
        let uuidName = InputList.displaySelectedInput()
        selectedDeviceUUID = uuidName
    }
    
    func selectNewInputInModel() {
        InputList.deSelectAllInputs()
        InputList.updateSelectedUUID(item: selectedInput, isSelected: true)
    }
    
    func generateInputListDefaults()  {
        for i in 1...4 {
            $inputList.append(InputList.generateDefaultObject(num: i))
        }
    }
}

#Preview {
    SegmentedSwitchView()
}
