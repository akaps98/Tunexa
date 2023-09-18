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
    @StateObject private var songViewModel = SongViewModel()
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(songViewModel)
        }
    }
}
