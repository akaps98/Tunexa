//
//  DashBoardView.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 12/09/2023.
//

import SwiftUI

struct DashBoardView: View {
    @State private var name: String = ""
    @State var isDark: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: -----BACKGROUND-----
                Color("bg-color")
                    .edgesIgnoringSafeArea(.all)
                
                // MARK: -----CONTENT-----
                ScrollView {
                    // MARK: BODY
                    VStack {
                        ForEach(0..<15) {_ in
                            SongRow()
                        }
                    }
                }
            }
            // MARK: HEADER
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Search")
                        .font(.custom("Nunito-Bold", size: 25))
                }
                
                // Dark Mode toggle button on the right-handed side of navigation bar
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 5) {
                        Button {
                            print("Setting View")
                        } label: {
                            Image(systemName: "gearshape")
                                .font(.system(size: 20))
                                .foregroundColor(Color("text-color"))
                        }
                        
                        Button {
                            isDark.toggle()
                        } label: {
                            // Display the icon accordingly based on the color scheme
                            if !isDark {
                                Image(systemName: "moon")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color("text-color"))
                            } else {
                                Image(systemName: "sun.min")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color("text-color"))
                            }
                        }
                    }
                    
                }
                
            }
           
        }
        .searchable(text: $name)
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct DashBoardView_Previews: PreviewProvider {
    static var previews: some View {
        DashBoardView()
    }
}
