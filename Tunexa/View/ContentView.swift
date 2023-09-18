//
//  ContentView.swift
//  Tunexa
//
//  Created by Tony on 2023/09/12.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var songViewModel = SongViewModel()
    @State var isDark: Bool = false
    var body: some View {
        TabView {
            DashBoardView(songViewModel: songViewModel, isDark: $isDark)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            SearchView(songViewModel: songViewModel, isDark: $isDark)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            LibraryView(songViewModel: songViewModel)
                .tabItem {
                    Label("Library", systemImage: "music.note.list")
                }
            AccountView(isDark: $isDark)
                .tabItem {
                    Label("Account", systemImage: "person")
                }
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
