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
               // print(" onChange selectedInput: \(selectedInput.singlePeripheralUUID)")
                selectNewInputInModel()
                displaySelectedInput()
            }
        }.onAppear() {
            if inputList.isEmpty {
                generateInputListDefaults()
            }
            displaySelectedInput()
        }
        //Text("Selected UUID: \(selectedDeviceUUID)").padding()
    }
    
    func displaySelectedInput() {
        let uuidName = InputList.displaySelectedInput()
        //print("\ngot selected item from model: \(uuidName)")
        selectedDeviceUUID = uuidName
    }
    
    func selectNewInputInModel() {
        //print("inside displaySelectedInput")
        InputList.deSelectAllInputs()
        //print("unpate next")
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
