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


import SwiftUI
import RealmSwift

struct ContentView: View {
    
    @ObservedResults(LumbarList.self) var lumbarList
    @ObservedResults(LumbarList.self, where: ( { $0.leftSelected == true } )) var lumbarListLeft
    @ObservedResults(LumbarList.self, where: ( { $0.leftSelected == false } )) var lumbarListRight
    
    @State var leftSelected: Bool = true
    
    var body: some View {
        NavigationView {
            VStack {
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
                        if leftSelected {
                            ForEach(lumbarListLeft, id: \.id) { lumbar in
                                LumbarRow(id: lumbar.id)
                            }
                        } else {
                            ForEach(lumbarListRight, id: \.id) { lumbar in
                                LumbarRow(id: lumbar.id)
                            }
                        }
                    }
                    .scrollContentBackground(.hidden).padding(.top, -25)
                    HStack {
                        SelectButton(isSelected: $leftSelected,
                                     text: "LEFT")
                        .onTapGesture {
                            leftSelected = true
                        }
                        SelectButton(isSelected: $leftSelected.not ,
                                     text: "RIGHT")
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
    
    func generateLumbatListDefaults()  {
        // left
        let retrievedObject = LumbarList()
        retrievedObject.title = "L1"
        retrievedObject.axial = 5.0
        retrievedObject.sagital = 10.0
        retrievedObject.leftSelected = true
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
    
    //MARK: - todo - can I use a switch to filter and poulate the List
    private func filterLeft() -> LazyFilterSequence<Results<LumbarList>> {
        var leftOnly = lumbarList.filter { $0.leftSelected }
        switch leftSelected {
        case true:
            leftOnly = lumbarList.filter { $0.leftSelected }
        case false:
            leftOnly = lumbarList.filter { !$0.leftSelected }
        }
        return leftOnly
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
