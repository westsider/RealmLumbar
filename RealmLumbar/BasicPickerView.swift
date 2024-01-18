//
//  BasicPickerView.swift
//  RealmLumbar
//
//  Created by Warren Hansen on 1/18/24.
//

import SwiftUI
import RealmSwift

struct BasicPickerView: View {

    @State var uuids = ["1", "2", "3", "4"]
    
    @State var selected = 1
    
    @ObservedResults(InputList.self) var inputList
    
    @State private var selectedInput: InputList = InputList()
    
    var body: some View {
        
        VStack {
            Picker(selection: $selected) {
                Text(uuids[0]).tag(1)
                Text(uuids[1]).tag(2)
                Text(uuids[2]).tag(3)
                Text(uuids[3]).tag(4)
            }    label: {
                Text("Label")
            }
            .pickerStyle(.segmented)
            let selectedUUID = uuids[selected - 1]
            Text(selectedUUID)
        }.onAppear() {
            InputList.deleteInputListRealm()
            if inputList.isEmpty {
                generateInputListDefaults()
                populateListNames()
            }
        }.onChange(of: selected) { newValue in
            let indexSelected = selected - 1
            let newUUID = uuids[indexSelected]
            print("selected uuid \(newUUID)")
            let selectedInputList = inputList[indexSelected]
            print(selectedInputList)
            if !inputList.isEmpty {
               updateModelWith(selectedInput: selectedInputList)
            }
        }
    }
    
    func generateInputListDefaults()  {
        print("\n----- generating new input list ----")
        for i in 1...4 {
            $inputList.append(InputList.generateDefaultObject(num: i))
            print("generated list \(inputList.count)")
        }
    }
    
    func populateListNames() {
        print("retrieved list \(inputList.count)")
        for (i, item)  in inputList.enumerated() {
            print(item.singlePeripheralUUID)
            uuids[i] = item.singlePeripheralUUID
        }
    }
    
    func updateModelWith(selectedInput: InputList) {
        InputList.deSelectAllInputs()
        InputList.updateSelectedUUID(item: selectedInput, isSelected: true)
    }
}

#Preview {
    BasicPickerView()
}
