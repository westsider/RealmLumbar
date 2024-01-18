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
                    Text("\(index.singlePeripheralUUID)").tag(index.id)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            .onChange(of: selectedInput) { newIndex in
                selectNewInputInModel()
                displaySelectedInput()
            }
        }
        .onAppear() {
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

//struct PickerView: View {
//    var color: UIColor
//    @State var pickerSelection = 0
//
//    var body: some View {
//        Picker(selection: $pickerSelection, label: Text("")) {
//            Text("Active").tag(0).foregroundColor(Color.white)
//            Text("Completed").tag(1)
//        }.pickerStyle(SegmentedPickerStyle()).foregroundColor(Color.orange)
//        .onAppear {
//            UISegmentedControl.appearance().tintColor = color
//        }
//    }
//}

#Preview {
    SegmentedSwitchView()
    //PickerView(color: .orange)
}
