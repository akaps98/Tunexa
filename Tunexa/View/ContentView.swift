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
  Acknowledgement:
  - TabView: Swift Playgrounds - About Me
  - Customized background color for Tabbar using toolbar background: https://developer.apple.com/documentation/swiftui/view/toolbarbackground(_:for:)-5ybst
*/

import SwiftUI

struct ContentView: View {
    // MARK: ***** PROPERTIES *****
    @State var isDark: Bool = false
    @EnvironmentObject var songViewModel: SongViewModel
    
    var body: some View {
        TabView {
            HomeView(isDark: $isDark)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .toolbarBackground(.visible, for: .tabBar) // Customize static background color for TabView
            
            SearchView(isDark: $isDark)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .toolbarBackground(.visible, for: .tabBar)
            
            LibraryView(isDark: $isDark)
                .tabItem {
                    Label("Library", systemImage: "music.note.list")
                }
                .toolbarBackground(.visible, for: .tabBar)
            
            AccountView(isDark: $isDark)
                .tabItem {
                    Label("Account", systemImage: "person")
                }
                .toolbarBackground(.visible, for: .tabBar)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SongViewModel())
    }
}
