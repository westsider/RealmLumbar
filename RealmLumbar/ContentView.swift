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
                    if lumbarList.isEmpty {
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
                                .listRowBackground(selectedItemId == item.id ? Color(.systemFill) : Color(.systemBackground))
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
                            }
                        SelectButton(isSelected: $leftSelected.not, text: "RIGHT")
                            .onTapGesture {
                                leftSelected = false
                            }
                    }
                    Button {
                        deleteRealm()
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
                    if lumbarList.isEmpty {
                        generateLumbatListDefaults()
                    }
                }
                CrosshairView()
            }.padding()
        }
    }
    
    private func updateSeletedItem(_ item: LumbarList) {
        print("Selected Item: ID: \(item.id), AX: \(item.axial), SG: \(item.sagital)")
    }
    
    // this crashes the app
    // selection highlight is working, not passing in a lumbsr, its nil
    private func updateModelWith() {
        
        // remove old isSelected
        //let lastSelection = lumbarList.filter { $0.isSelected }
        
        // persist this
        //print("updateModelWith got id: \(selectedLumbar)")
        
        // when realm write is added the ui stops being selected
        DispatchQueue.global(qos: .background).async {
            
            // move this to the model
            do {
                let realm = try Realm()
                try realm.write {
                    //guard let objectFiltered = realm.object(ofType: LumbarList.self, forPrimaryKey: id) else {return  }
                    //                        let objectFiltered = lumbarList.filter { $0.id == id}
                    //                        print(objectFiltered)
                    //                        // delselxct last lumbar
                    //                        if !lastSelection.isEmpty {
                    //                            lastSelection.first?.isSelected = false
                    //                        }
                    //                        // mark new lumbar as selected
                    //                        selectedLumbar!.isSelected = true
                }
            }
            catch {
                print(error)
            }
        }
    }
    
    func generateLumbatListDefaults()  {
        // left
        let retrievedObject = LumbarList()
        retrievedObject.title = "L1"
        retrievedObject.axial = 5.0
        retrievedObject.sagital = 10.0
        retrievedObject.leftSelected = true
        retrievedObject.isSelected = true
        $lumbarList.append(retrievedObject)
        
        let retrievedObject2 = LumbarList()
        retrievedObject2.title = "L2"
        retrievedObject2.axial = 15.0
        retrievedObject2.sagital = 20.0
        retrievedObject2.leftSelected = true
        $lumbarList.append(retrievedObject2)
        // roght
        let retrievedObject3 = LumbarList()
        retrievedObject3.title = "L1"
        retrievedObject3.axial = 30.0
        retrievedObject3.sagital = 35.0
        retrievedObject3.leftSelected = false
        $lumbarList.append(retrievedObject3)
        
        let retrievedObject4 = LumbarList()
        retrievedObject4.title = "L2"
        retrievedObject4.axial = 40.0
        retrievedObject4.sagital = 45.0
        retrievedObject4.leftSelected = false
        $lumbarList.append(retrievedObject4)
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
    
    private func deleteRealm() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
}

#Preview {
    ContentView()
}


struct CrosshairView: View {
    var body: some View {
        Text("recieved lumbar...")
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
