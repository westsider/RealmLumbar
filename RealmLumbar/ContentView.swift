//
//  ContentView.swift
//  RealmLumbar
//
//  Created by Warren Hansen on 1/9/24.

//  [X] Add left right
//  [X] selected row is colored
//  [X] filted left and right on list
//  [X] add left/right when we add new object
//  [ ] add a crosshair struct to set how its updated

//  how do I pass selected row to crosshair? can I send the id?
//  how do I pass in hold and offset?

//  future
//  how do I know what data stream is selected? need a var for selectedUUID
//  how do I set hold or offset? need a var somewhere for offsetOn, hold on

/*
 Friday
 Get selected lumbar persisting
 Pass that to crosshair
 */
import SwiftUI
import RealmSwift

struct ContentView: View {
    
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
                            LumbarRow(id: item.id)
                                .tag(item.id)
                                .contentShape(Rectangle()) //makes whole row tappable
                                .onTapGesture {
                                    self.selectedItemId = item.id
                                }
                                .listRowBackground(selectedItemId == item.id ? Color.blue.opacity(0.5) : Color.gray.opacity(0.2))
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
                    Button {
                        LumbarList.deleteRealm()
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
                CrosshairView()
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
        let num = lumbarList.count + 1
        let retrievedObject = LumbarList()
        retrievedObject.title = "L\(num)"
        retrievedObject.axial = 10.0
        retrievedObject.sagital = 10.0
        retrievedObject.leftSelected = leftOn
        $lumbarList.append(retrievedObject)
        
    }
}

#Preview {
    ContentView()
}


struct CrosshairView: View {
    
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
                Text("\(lumbar.title) - Axial: \(lumbar.axial), Sagital: \(lumbar.sagital)")
            }
            let newItem: String = items.first?.singlePeripheralUUID ?? "no item"
            Text("Selected Input: \(newItem)")
            HStack {
                ForEach(holdOffsetState) { state in
                    if state.isHoldButtonOn {
                        Text("holding")
                    } else {
                        Text("Not Holding")
                    }
                }
                ForEach(holdOffsetState) { state in
                    if state.isOffsetButtonOn {
                        Text("Offset")
                    } else {
                        Text("Not Offset")
                    }
                }
            }
            
        }.onAppear() {
            displaySelectedInput()
            populateInputListWithAvailableDevices()
        }
    }
    
//    func showHoldingState() -> Text {
//        var holdingText = "NA"
//        //ForEach(holdOffsetState) { state in
//        if ((holdOffsetState.first?.isHoldButtonOn) != nil) {
//                holdingText = ("holding")
//            } else {
//                holdingText = "Not Holding"
//            }
//        //}
//        return Text(holdingText)
//    }
    
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
    
    /*
     //MARK: - Todo - place this check in the crosshair view where its first called
     func checkForExistingHoldOffsetObject() {
     if let id = holdOffsetState.first?.id {
     print(id)
     } else {
     print("failed to get id for HOLDOFFSET")
     // becaue we need to create the first object
     $holdOffsetState.append(HoldOffsetState.createFirstObject(holdState: isHoldButtonOn, offsetState: isOffsetButtonOn))
     }
     
     }
     */
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
