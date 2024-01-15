//
//  RealmLumbarApp.swift
//  RealmLumbar
//
//  Created by Warren Hansen on 1/9/24.
//

import SwiftUI

@main
struct RealmLumbarApp: App {
    
    let migrator = Migrator()
    
    var body: some Scene {
        WindowGroup {
            TestScreen()
            //ContentView()
            //let _ = print("\n\(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)\n")
        }
    }
}

