//
//  DashBoardView.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 12/09/2023.
//


import SwiftUI

struct DashBoardView: View {
    let columns = 2
    @Binding var isDark: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: -----BACKGROUND-----
                Color("bg-color")
                    .edgesIgnoringSafeArea(.all)
                
                // MARK: -----CONTENT-----
                ScrollView {
                    VStack {
                        // MARK: HEADER
                        HStack {
                            Text("Good Morning")
                                .font(.custom("Nunito-Bold", size: 25))
                            
                            Spacer()
                            
                            HStack(spacing: 10) {
                                Button {
                                    print("Setting View")
                                } label: {
                                    Image(systemName: "gearshape")
                                        .font(.system(size: 25))
                                        .foregroundColor(Color("text-color"))
                                }
                                
                                Button {
                                    isDark.toggle()
                                } label: {
                                    // Display the icon accordingly based on the color scheme
                                    if !isDark {
                                        Image(systemName: "moon")
                                            .font(.system(size: 25))
                                            .foregroundColor(Color("text-color"))
                                    } else {
                                        Image(systemName: "sun.min")
                                            .font(.system(size: 25))
                                            .foregroundColor(Color("text-color"))
                                    }
                                }
                            }
                        }
                        
                        // MARK: FILTER OPTIONS
                        HStack {
                            Button {
                                print("Toggle Music")
                            } label: {
                                Text("Music")
                                    .font(.custom("Nunito-Medium", size: 16))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 25)
                                    .padding([.top, .bottom], 5)
                                    .background(Color("secondary-color"), in: Capsule())
                            }
                            
                            Button {
                                print("Toggle Artists")
                            } label: {
                                Text("Artists")
                                    .font(.custom("Nunito-Medium", size: 16))
                                    .foregroundColor(Color("text-color"))
                                    .padding(.horizontal, 25)
                                    .padding([.top, .bottom], 5)
                                    .background(Color("light-gray"), in: Capsule())
                                
                            }
                            
                            Spacer()
                            
                        }
                        
                        // MARK: PLAYLISTS
                        LazyVGrid(columns: Array(repeating: GridItem(), count: columns)) {
                            ForEach(0..<6) {_ in
                                
                            }
                        }
                        
                        // MARK: ALL SONGS
                        HStack {
                            Text("All Songs")
                                .font(.custom("Nunito-Bold", size: 22))
                            Spacer()
                        }
                        ScrollView(.horizontal) {
                            HStack(spacing: 15) {
                                ForEach(0..<10) {_ in
                                    SongColumn()
                                }
                            }
                            
                        }
                        
                        // MARK: ALL ARTISTS
                        HStack {
                            Text("All Artists")
                                .font(.custom("Nunito-Bold", size: 22))
                            Spacer()
                        }
                        ScrollView(.horizontal) {
                            HStack(spacing: 15) {
                                ForEach(0..<15) {_ in
                                    ArtistColumn()
                                }
                            }
                            
                        }
                        
                        // MARK: ALL CATEGORIES
                        HStack {
                            Text("Browse all")
                                .font(.custom("Nunito-Bold", size: 20))
                            Spacer()
                        }
                        LazyVGrid(columns: Array(repeating: GridItem(), count: columns)) {
                            ForEach(0..<15) {_ in
                                CategoryRow()
                            }
                        }
                    } // VStack
                    .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .environment(\.colorScheme, isDark ? .dark : .light) // modify the color sheme based on the state variable
    }
}

struct DashBoardView_Previews: PreviewProvider {
    static var previews: some View {
        DashBoardView(isDark: .constant(false))
    }
}
