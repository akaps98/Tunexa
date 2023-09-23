/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Team: Squad 21 (Group 21)
  Members:
  1. Nguyen Anh Duy (s3878141)
  2. Seoungjoon Hong (s3726123)
  3. Junsik Kang (s3916884)
  4. Christina Yoo (s3938331)
  5. Nguyen Hoang Viet (s3926104)
  Created date: 12/09/2023
  Last modified: 22/09/2023
  Acknowledgement: None
*/

import SwiftUI
import FirebaseCore

@main
struct TunexaApp: App {
    // MARK: ***** PROPERTIES *****
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
