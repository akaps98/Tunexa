//
//  ContentView.swift
//  Tunexa
//
//  Created by Tony on 2023/09/12.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DashBoardView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
