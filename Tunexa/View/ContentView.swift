//
//  ContentView.swift
//  Tunexa
//
//  Created by Tony on 2023/09/12.
//

import SwiftUI

struct ContentView: View {
    @State var isDark: Bool = false
    var body: some View {
        TabView {
            DashBoardView(isDark: $isDark)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            SearchView(isDark: $isDark)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            LibraryView()
                .tabItem {
                    Label("Library", systemImage: "music.note.list")
                }
            AccountView()
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
