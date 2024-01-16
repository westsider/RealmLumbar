//
//  HoldOffsetView.swift
//  RealmLumbar
//
//  Created by Warren Hansen on 1/16/24.
//

import SwiftUI

// [X] pressing hold changes button to clear hold
// [X] add model hold bool. hold value
// [ ] add state to crosshair
// [ ] in crosshair when button pressed get/persist hold value from datastream - object func
//  [ ] in crosshair show hold values - object func
//  [ ] HOLDING AT - red
//  [ ] 61.5 - - boxed
//  [ ] later but have infrastructure
//  [ ] final get hold on off and values from main view

// offset presssed clear offset, digital numbers got to 0.0

import RealmSwift

class HoldOffsetState: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var isHoldButtonOn = false
    @Persisted var isOffsetButtonOn = false
    @Persisted var holdValue: Double  = 0.0
    @Persisted var offsetValue: Double  = 0.0
    
    override class func primaryKey() -> String? {
        "id"
    }
    
    static func createFirstObject(holdState: Bool, offsetState: Bool) -> HoldOffsetState {
        let retrievedObject = HoldOffsetState()
        retrievedObject.isHoldButtonOn = holdState
        retrievedObject.isOffsetButtonOn = offsetState
        retrievedObject.holdValue  = 0.0
        retrievedObject.offsetValue  = 0.0
        return retrievedObject
    }
     
    static func updateButtonState(id: ObjectId, isHoldButtonOn: Bool, isOffsetButtonOn: Bool) {
        do {
            let realm = try Realm()
            
            if let buttonToChange = realm.object(ofType: HoldOffsetState.self, forPrimaryKey: id) {
                try realm.write {
                    buttonToChange.isHoldButtonOn = isHoldButtonOn
                    buttonToChange.isOffsetButtonOn = isOffsetButtonOn
                }
            }
        } catch {
            print("An error occurred while updating the LumbarList: \(error)")
        }
    }
}


struct HoldOffsetView: View {
    @State private var isHoldButtonOn = false
    @State private var isOffsetButtonOn = false
    @ObservedResults(HoldOffsetState.self) var holdOffsetState
    let buttonColor = Color.gray.opacity(0.3)
    
    var body: some View {
        HStack {
            Button(action: {
                self.isHoldButtonOn.toggle()
                if self.isHoldButtonOn {
                    self.isOffsetButtonOn = false
                }
                persistValuesToRealm()
            }) {
                Text(isHoldButtonOn ? "CLEAR HOLD" : "HOLD")
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .foregroundColor(.black)
                    .padding()
                    .background(isHoldButtonOn ? Color.blue.opacity(0.5) : buttonColor)
                    //.cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.black, lineWidth: 2)
                    )
                
            }
            .disabled(isOffsetButtonOn)
            
            Button(action: {
                self.isOffsetButtonOn.toggle()
                if self.isOffsetButtonOn {
                    self.isHoldButtonOn = false
                }
                persistValuesToRealm()
            }) {
                Text(isOffsetButtonOn ? "CLEAR OFFSET" : "OFFSET")
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .foregroundColor(.black)
                    .padding()
                    .background(isOffsetButtonOn ? Color.blue.opacity(0.5) : buttonColor)
                    //.cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.black, lineWidth: 2)
                    )
            }
            .disabled(isHoldButtonOn)
        }.onAppear() {
            checkForExistingHoldOffsetObject()
        }
        .padding()
    }

    func persistValuesToRealm() {
        if let id = holdOffsetState.first?.id {
           // print(id)
            HoldOffsetState.updateButtonState(id: id, isHoldButtonOn: isHoldButtonOn, isOffsetButtonOn: isOffsetButtonOn)
        } else {
            print("failed to get HOLDOFFSET id")
        }
    }
    
    //MARK: - Todo - place this check in the crosshair view where its first called
    func checkForExistingHoldOffsetObject() {
        if let id = holdOffsetState.first?.id {
            //print(id)
        } else {
            print("failed to get id for HOLDOFFSET")
            // becaue we need to create the first object
            $holdOffsetState.append(HoldOffsetState.createFirstObject(holdState: isHoldButtonOn, offsetState: isOffsetButtonOn))
        }
    }
}


#Preview {
    HoldOffsetView()
}
