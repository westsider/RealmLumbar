//
//  ContentView.swift
//  RealmLumbar
//
//  Created by Warren Hansen on 1/9/24.

import SwiftUI
import RealmSwift

struct LumbarListView: View {
    
    @ObservedResults(LumbarList.self) var lumbarList
    @State var leftSelected: Bool = true
    @State private var selectedItemId: ObjectId?
    
    var items: Results<LumbarList> {
        let realm = try! Realm()
        return realm.objects(LumbarList.self).filter("leftSelected == %@", leftSelected)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                /// list titles of AX and SG
                HStack {
                    Spacer(minLength: 100)
                    Text(" ")
                    Spacer()
                    Text("AX").bold()
                    Spacer()
                    Text("SG").foregroundStyle(.gray)
                    Spacer()
                }.offset(x: -30, y: 0)
                VStack {
                    if items.isEmpty {
                        Text("Lumbar List is Empty")
                    }
                    List {
                        ForEach(items, id: \.id) { item in
                            if !items.isEmpty {
                                LumbarRow(id: item.id)      // crash here when delete all added check
                                    .tag(item.id)
                                    .contentShape(Rectangle()) //makes whole row tappable
                                    .onTapGesture {
                                        self.selectedItemId = item.id
                                    }
                                    .listRowBackground(selectedItemId == item.id ? Color.blue.opacity(0.5) : Color.gray.opacity(0.2))
                            }
                        }
                    }
                    .onChange(of: selectedItemId) { newItemId in
                        if let newItemId = newItemId,
                           let selectedItem = items.first(where: { $0.id == newItemId }) {
                            updateSeletedItem(selectedItem)
                        }
                    }
                    .scrollContentBackground(.hidden).padding(.top, -25)
                    
                    /// LEFT and RIGHT buttons
                    HStack {
                        SelectButton(isSelected: $leftSelected,  text: "LEFT")
                            .onTapGesture {
                                leftSelected = true
                                switchSideSelectsFirstLumbar()
                            }
                        SelectButton(isSelected: $leftSelected.not, text: "RIGHT")
                            .onTapGesture {
                                leftSelected = false
                                switchSideSelectsFirstLumbar()
                            }
                    }
                    /// clear all button
                    Button {
                        LumbarList.deleteLumbarListRealm()
                        generateLumbatListDefaults()
                    } label: {
                        Text("CLEAR ALL")
                            .frame(maxWidth: .infinity, maxHeight: 40)
                    }
                    .buttonStyle(GreyButtonSimple())
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            newLumbarObject(leftOn: leftSelected)
                        } label: {
                            Image(systemName: "plus")
                                .foregroundStyle(Color.black)
                        }
                        
                    }
                }.onAppear() {
                    switchSideSelectsFirstLumbar()
                    if items.isEmpty {
                        generateLumbatListDefaults()
                    }
                }
                Spacer()
                //----------------------------
                // this is the main view
                //-----------------------------
                CrosshairViewTestDisplay()
                //----------------------------
                // this is theinput switch
                //-----------------------------
                SegmentedSwitchView()
                //----------------------------
                // this is hold offset switches
                //-----------------------------
                HoldOffsetView()
            }.padding()
        }
    }
    
    private func switchSideSelectsFirstLumbar() {
        if let firstRow = items.first {
            self.selectedItemId = firstRow.id
            updateSeletedItem(firstRow)
            self.selectedItemId = firstRow.id
        }
    }
    
    private func updateSeletedItem(_ item: LumbarList) {
        LumbarList.removeIsSectedItem()
        LumbarList.updateItemAsSelected(item: item)
    }
    
    
    func generateLumbatListDefaults()  {
        for i in 1...4 {
            $lumbarList.append(LumbarList.generateDefaultObject(num: i))
        }
    }
    
    func newLumbarObject(leftOn: Bool)  {
        let num = items.count + 1
        let retrievedObject = LumbarList()
        retrievedObject.title = "L\(num)"
        retrievedObject.axial = 10.0
        retrievedObject.sagital = 10.0
        retrievedObject.leftSelected = leftOn
        $lumbarList.append(retrievedObject)
        
    }
}

#Preview {
    LumbarListView()
}

struct CrosshairViewTestDisplay: View {
    
    @ObservedResults(LumbarList.self, where: { $0.isSelected == true }) var selectedLumbars
    
    @ObservedResults(InputList.self) var inputList
    
    @ObservedResults(HoldOffsetState.self) var holdOffsetState
    
    @State private var selectedDeviceUUID: String = "No Device"
    
    @State private var isHolding: Bool = false
    
    var items: Results<InputList> {
        let realm = try! Realm()
        return realm.objects(InputList.self).filter("isSelectd == %@", true)
    }
    
    var body: some View {
        VStack {
            if inputList.isEmpty {
                Text("No inputs Available")
            }
            // may want to pick first incase more than one is selected bug
            Text("CrossHair")
            ForEach(selectedLumbars) { lumbar in
                let axial = Utilities.oneDecimal(fromDouble: lumbar.axial)
                let sagittal = Utilities.oneDecimal(fromDouble: lumbar.sagital)
                Text("\(lumbar.title) - Axial: \(axial), Sagital: \(sagittal)")
            }
            let newItem: String = items.first?.singlePeripheralUUID ?? "no item"
            Text("Selected Input: \(newItem)")
            // hold / offset button states
            HStack {
                Text("Hold Button: \(holdOffsetState.first?.isHoldButtonOn ?? false ? "On" : "Off")")
                Text("Offset Button: \(holdOffsetState.first?.isOffsetButtonOn ?? false ? "On" : "Off")")
            }
            VStack {
                
                if let firstHoldOffsetState = holdOffsetState.first {
                    let axial = Utilities.oneDecimal(fromDouble: firstHoldOffsetState.holdValueAxial)
                    let sagittal = Utilities.oneDecimal(fromDouble: firstHoldOffsetState.holdValueSagittal)
                    
                    //show hold values only when holding is true
                    if let holding = holdOffsetState.first?.isHoldButtonOn {
                        if holding  {
                            Text("HOLDING AT: Ax: \(axial)")
                            Text("HOLDING AT:  Sg: \(sagittal)")
                        }
                    }
                    
                    let axialOffset = Utilities.oneDecimal(fromDouble: firstHoldOffsetState.offsetValueAxial)
                    let sagittalOffset = Utilities.oneDecimal(fromDouble: firstHoldOffsetState.offsetValueSagittal)
                    //show offset values only when offset is true
                    if let offset = holdOffsetState.first?.isOffsetButtonOn {
                        if offset  {
                            Text("Offset AT: Ax: \(axialOffset)")
                            Text("offset AT:  Sg: \(sagittalOffset)")
                        }
                    }
                }
            }   /// when a change of the hold buttton is detected, get the hold values
            .onChange(of: holdOffsetState.first?.isHoldButtonOn) {  newValue in
                if newValue ?? false {
                    //print("hold is true")
                    //MARK: - TODO: - get hold values from selected input
                    updateHoldValues(axial: 100.0, sagittal: -200.0 )
                } else {
                   // print("hold is false")
                    updateHoldValues(axial: 0.0, sagittal: 0.0 )
                }
            } // change of offset button
            .onChange(of: holdOffsetState.first?.isOffsetButtonOn) {  newValue in
                if newValue ?? false {
                    //print("hold is true")
                    //MARK: - TODO: - get offset values from selected input
                    updateOffsetValues(axial: 99.9, sagittal: 88.8 )
                } else {
                   // print("hold is false")
                    // reset offset to 0.0
                    updateOffsetValues(axial: 0.0, sagittal: 0.0 )
                }
            }
            
        }.onAppear() {
            populateInputListWithAvailableDevices()
            populateHoldOffsetObject()
            displaySelectedInput()
        }
    }
    

    func getHoldStateFromMainView() {
        
        // MARK: - TODO: - get these values from the persusted main view values and test the functions
        let holdFromMain: Bool = false
        let offsetFromMain: Bool = false
        let axialHold: Double = 20.0
        let sagittalHold: Double = 40.0
        let axialOffset: Double = 20.0
        let sagittalOffset: Double = 40.0
        
        // if Hold is true from main view update button state and values with this func
        guard let object = holdOffsetState.first else { return }
        if holdFromMain {
            HoldOffsetState.updateButtonState(id: object.id, isHoldButtonOn: holdFromMain, isOffsetButtonOn: false)
            HoldOffsetState.persistHoldValues(id: object.id, axial: axialHold, sagittal: sagittalHold)
        }
        
        // if Offset is true from main screen, update button state and values with this func
        if offsetFromMain {
            HoldOffsetState.updateButtonState(id: object.id, isHoldButtonOn: false, isOffsetButtonOn: offsetFromMain)
            HoldOffsetState.persistOffsetValues(id: object.id, axial: axialOffset, sagittal: sagittalOffset)
        }
        
    }
    
    func updateHoldValues(axial: Double, sagittal: Double) {
        if let thisObject = holdOffsetState.first {
            HoldOffsetState.persistHoldValues(id: thisObject.id, axial: axial, sagittal: sagittal)
        }
    }
    
    //////--------------
    func updateOffsetValues(axial: Double, sagittal: Double) {
        if let thisObject = holdOffsetState.first {
            HoldOffsetState.persistOffsetValues(id: thisObject.id, axial: axial, sagittal: sagittal)
        }
    }
    
    // replace 1 - 4 with actual id's
    func displaySelectedInput() {
        selectedDeviceUUID = items.first?.singlePeripheralUUID ?? "No Selection"
    }
    
    func populateInputListWithAvailableDevices() {
        // just the first one for now...
        // get the first
        guard let firstSwitch = InputList.getObjectWith(uuid: "Device 1").first else { return }
        //print("here is the first switch \(firstSwitch.singlePeripheralUUID)")
        // update the object
        InputList.updateItemPerifUUID(item: firstSwitch, newUUID: "RJB6 1234.5678")
    }
    
    func populateHoldOffsetObject() {
        if let _ = holdOffsetState.first?.id {
            //print(id)
        } else {
            // print("failed to get id for HOLDOFFSET")
            // becaue we need to create the first object
            $holdOffsetState.append(HoldOffsetState.createFirstObject(holdState: false, offsetState: false))
        }
        
    }
    
}
struct GreyButtonSimple: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .bold()
            .buttonStyle(.bordered)
            .background( Color.gray.opacity(0.3))
            .foregroundColor(.black)
            .border(Color.gray.opacity(0.3), width: 2)
            .cornerRadius(5)
    }
}

struct SelectButton: View {
    
    @Binding var isSelected: Bool
    @State var text: String
    
    var body: some View {
        ZStack {
            Text(text)
                .frame(maxWidth: .infinity, maxHeight: 40)
                .font(.headline)
                .buttonStyle(.bordered)
                .foregroundColor(.black)
                .background(isSelected ?  Color.blue.opacity(0.5) : Color.gray.opacity(0.3))
                .border(isSelected ?  Color.black.opacity(0.5) : Color.gray.opacity(0.3), width: 2)
                .cornerRadius(5)
        }
    }
}
