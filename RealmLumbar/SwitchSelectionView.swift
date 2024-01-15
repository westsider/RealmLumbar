////
////  SwitchSelectionView.swift
////  RealmLumbar
////
////  Created by Warren Hansen on 1/15/24.
////
//
//import SwiftUI
//import RealmSwift
//
//import SwiftUI
//import RealmSwift
//
//struct ContentView2: View {
//    @StateObject var selectedSwitchModel = SelectedSwitchModel()
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text("hello")
//                //SwitchSelectionView(selectedSwitchModel: selectedSwitchModel)
//                //DisplaySelectedSwitchView(selectedSwitchModel: selectedSwitchModel)
//            }
//            .navigationBarTitle("Switch Example")
//        }
//    }
//}
//
//
//
//
//struct SwitchSelectionView: View {
//    @State private var selectedSwitchIndex: Int = 0
//    @ObservedObject var selectedSwitchModel: SelectedSwitchModel
//    
//    var switchTitles: [String] {
//        // Fetch the titles from your Realm string array here
//        // You should replace this with your actual code to fetch titles
//        return ["Option 1", "Option 2", "Option 3", "Option 4"]
//    }
//    
//    var body: some View {
//        VStack {
//            Picker("Select a switch", selection: $selectedSwitchIndex) {
//                ForEach(0..<switchTitles.count, id: \.self) { index in
//                    Text(switchTitles[index]).tag(index)
//                }
//            }
//            .pickerStyle(SegmentedPickerStyle())
//            .padding()
//            
//            Button("Save") {
//                // Save the selected switch to Realm
//                let selectedSwitch = switchTitles[selectedSwitchIndex]
//                try! selectedSwitchModel.realm?.write {
//                    selectedSwitchModel.selectedSwitch = selectedSwitch
//                }
//            }
//        }
//        .padding()
//    }
//}
//
//import SwiftUI
//import RealmSwift
//
//struct DisplaySelectedSwitchView: View {
//    @ObservedObject var selectedSwitchModel: SelectedSwitchModel
//    
//    var body: some View {
//        VStack {
//            Text("Selected Switch:")
//            Text(selectedSwitchModel.selectedSwitch)
//                .font(.largeTitle)
//        }
//        .padding()
//    }
//}
//
//
////#Preview {
////    ContentView2()
////    //SwitchSelectionView(selectedSwitchModel: //SwitchSelectionView(selectedSwitchModel: SelectedSwitchModel()))
////}
//
////import RealmSwift
////
////class SelectedSwitchModel: Object {
////    @Persisted var selectedSwitch: String = ""
////}
