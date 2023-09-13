//
//  TunexaApp.swift
//  Tunexa
//
//  Created by Tony on 2023/09/12.
//

import SwiftUI
import FirebaseCore

@main
struct TunexaApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
