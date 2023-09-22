//
//  ContentView.swift
//  Tunexa
//
//  Created by Tony on 2023/09/12.
//

import SwiftUI

struct ContentView: View {
    @State var isDark: Bool = false
    @EnvironmentObject var songViewModel: SongViewModel
    
    var body: some View {
        TabView {
            HomeView(isDark: $isDark)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .toolbarBackground(.visible, for: .tabBar)
            
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
