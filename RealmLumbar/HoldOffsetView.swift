//
//  HoldOffsetView.swift
//  RealmLumbar
//
//  Created by Warren Hansen on 1/16/24.
//

import SwiftUI

import RealmSwift

class HoldOffsetState: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var isHoldButtonOn = false
    @Persisted var isOffsetButtonOn = false
    @Persisted var holdValueSagittal: Double  = 0.0
    @Persisted var holdValueAxial: Double  = 0.0
    @Persisted var offsetValueSagittal: Double  = 0.0
    @Persisted var offsetValueAxial: Double  = 0.0
    
    override class func primaryKey() -> String? {
        "id"
    }
    
    static func createFirstObject(holdState: Bool, offsetState: Bool) -> HoldOffsetState {
        let retrievedObject = HoldOffsetState()
        retrievedObject.isHoldButtonOn = holdState
        retrievedObject.isOffsetButtonOn = offsetState
        retrievedObject.holdValueSagittal  = 0.0
        retrievedObject.holdValueAxial  = 0.0
        retrievedObject.offsetValueSagittal  = 0.0
        retrievedObject.offsetValueAxial  = 0.0
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
    
    // in crosshair when button pressed get/persist hold value from datastream - object func
    static func persistHoldValues(id: ObjectId, axial: Double, sagittal: Double) {
        
        do {
            let realm = try Realm()
            if let item = realm.object(ofType: HoldOffsetState.self, forPrimaryKey: id) {
                try realm.write {
                    item.holdValueAxial = axial
                    item.holdValueSagittal = sagittal
                }
            }
        } catch {
            print("An error occurred while updating the HoldOffsetState: \(error)")
        }
    }
    
    static func persistOffsetValues(id: ObjectId, axial: Double, sagittal: Double) {
        
        do {
            let realm = try Realm()
            if let item = realm.object(ofType: HoldOffsetState.self, forPrimaryKey: id) {
                try realm.write {
                    item.offsetValueAxial = axial
                    item.offsetValueSagittal = sagittal
                }
            }
        } catch {
            print("An error occurred while updating the HoldOffsetState: \(error)")
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
    
    func checkForExistingHoldOffsetObject() {
        if let _ = holdOffsetState.first?.id {
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
