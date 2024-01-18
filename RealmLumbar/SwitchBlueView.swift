//
//  SwitchBlueView.swift
//  RealmLumbar
//
//  Created by Warren Hansen on 1/18/24.
//

import SwiftUI
import RealmSwift

struct SwitchBlueView: View {
    
    @ObservedResults(InputList.self) var inputList
    
    @State private var selectedInput: InputList = InputList()
    
    @State private var selectedDeviceUUID: String = "No Device"
    
    var body: some View {
        if inputList.isEmpty {
            Text("No Inputs")
        }
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(inputList) { index in
                        Button {
                            selectedInput = index
                        } label: {
                            VStack {
                                Text("\(index.singlePeripheralUUID)")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundColor(selectedInput == index ? .blue : Color(uiColor: .systemGray))
                                ZStack {
                                    Capsule()
                                        .fill(Color.clear)
                                        .frame(height: 4)
                                    if selectedInput == index {
                                        Capsule()
                                            .fill(Color.blue)
                                            .frame(height: 4)
                                    }
                                }
                            }
                            .padding(.horizontal, 10)
                            
                        }
                        .buttonStyle(PlainButtonStyle())
                        .onChange(of: selectedInput) {  newValue in
                            selectNewInputInModel()
                            //displaySelectedInput()
                            print("selectedInput: \n\(selectedInput) : \nnewValue\n \(newValue)")
                            selectedInput = index
                            
                        }
                    }
                    
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            
            //Text(selectedInput.singlePeripheralUUID)
            // Rest of your code here
            
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

#Preview {
    SwitchBlueView()
}
