//
//  HoldOffsetView.swift
//  RealmLumbar
//
//  Created by Warren Hansen on 1/16/24.
//

import SwiftUI

// [X] pressing hold changes button to clear hold
// [ ] add model hold bool. hold value
// [ ] add state to crosshair
// [ ] in crosshair when button pressed get/persist hold value from datastream - object func
//  [ ] in crosshair show hold values - object func
//  [ ] HOLDING AT - red
//  [ ] 61.5 - - boxed
//  [ ] later but have infrastructure
//  [ ] final get hold on off and values from main view

// offset presssed clear offset, digital numbers got to 0.0

import SwiftUI

struct HoldOffsetView: View {
    @State private var isHoldButtonOn = false
    @State private var isOffsetButtonOn = false

    var body: some View {
        HStack {
            Button(action: {
                self.isHoldButtonOn.toggle()
                if self.isHoldButtonOn {
                    self.isOffsetButtonOn = false
                }
            }) {
                Text(isHoldButtonOn ? "CLEAR HOLD" : "HOLD")
                    .bold()
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .foregroundColor(.black)
                    .padding()
                    .background(isHoldButtonOn ? Color.blue.opacity(0.5) : Color.gray.opacity(0.5))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 2)
                    )
            }
            .disabled(isOffsetButtonOn)
            
            Button(action: {
                self.isOffsetButtonOn.toggle()
                if self.isOffsetButtonOn {
                    self.isHoldButtonOn = false
                }
            }) {
                Text(isOffsetButtonOn ? "CLEAR OFFSET" : "OFFSET")
                    .bold()
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .foregroundColor(.black)
                    .padding()
                    .background(isOffsetButtonOn ? Color.blue.opacity(0.5) : Color.gray.opacity(0.5))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 2)
                    )
            }
            .disabled(isHoldButtonOn)
        }
        .padding()
    }
}

#Preview {
    HoldOffsetView()
}
