//
//  DashBoardView.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 12/09/2023.
//


import SwiftUI

struct HomeView: View {
    // MARK: ***** PROPERTIES *****
    @EnvironmentObject var songViewModel: SongViewModel
    let colors : [Color] = [.red, .orange, .blue, .green, .cyan, .indigo, .pink, .yellow, .brown, .teal]
    let columns = 2
    @Binding var isDark: Bool
    @State var showAll = true
    @State var showMusicOnly = false
    @State var showCategoryOnly = false
    @State var showArtistOnly = false
    @State private var artists: [String: String] = [:]
    
    func setShowAll() {
        if !showMusicOnly && !showArtistOnly && !showCategoryOnly {
            showAll = true
        } else {
            showAll = false
        }
    }
    
    func getAttributes(){
        for song in songViewModel.songs{
            artists[song.author[0]!] = song.author[1] ?? ""
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: -----BACKGROUND-----
                Color("bg-color")
                    .edgesIgnoringSafeArea(.all)
                
                // MARK: -----CONTENT-----
                VStack {
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
                                        UITabBar.appearance().backgroundColor = UIColor(Color("bg-color"))
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
                                    showMusicOnly.toggle()
                                    setShowAll()
                                } label: {
                                    Text("Music")
                                        .font(.custom("Nunito-Medium", size: 16))
                                        .foregroundColor(showMusicOnly ? .white : Color("text-color"))
                                        .padding(.horizontal, 25)
                                        .padding([.top, .bottom], 5)
                                        .background(Color(showMusicOnly ? "secondary-color" : "light-gray"), in: Capsule())
                                }
                                
                                Button {
                                    showArtistOnly.toggle()
                                    setShowAll()
                                } label: {
                                    Text("Artists")
                                        .font(.custom("Nunito-Medium", size: 16))
                                        .foregroundColor(showArtistOnly ? .white : Color("text-color"))
                                        .padding(.horizontal, 25)
                                        .padding([.top, .bottom], 5)
                                        .background(Color(showArtistOnly ? "secondary-color" : "light-gray"), in: Capsule())
                                    
                                }
                                
                                Button {
                                    showCategoryOnly.toggle()
                                    setShowAll()
                                } label: {
                                    Text("Categories")
                                        .font(.custom("Nunito-Medium", size: 16))
                                        .foregroundColor(showCategoryOnly ? .white : Color("text-color"))
                                        .padding(.horizontal, 25)
                                        .padding([.top, .bottom], 5)
                                        .background(Color(showCategoryOnly ? "secondary-color" : "light-gray"), in: Capsule())
                                    
                                }
                                
                                Spacer()
                                
                            }
                            .offset(y: -8)
                            
                            // MARK: ALL SONGS
                            if showAll || showMusicOnly {
                                HStack {
                                    Text("All Songs")
                                        .font(.custom("Nunito-ExtraBold", size: 22))
                                    Spacer()
                                }
                                ScrollView(.horizontal) {
                                    HStack(spacing: 15) {
                                        ForEach(songViewModel.songs, id: \.id) {song in
                                            NavigationLink {
                                                SongCard(song: song, songs: songViewModel.songs)
                                            } label: {
                                                SongColumn(song: song)
                                                    .foregroundColor(Color("text-color"))
                                            }
                                            
                                        }
                                    }
                                }
                                .scrollIndicators(.hidden)
                                .padding(.bottom)
                            }
                            
                            
                            // MARK: ALL ARTISTS
                            if showAll || showArtistOnly {
                                HStack {
                                    Text("All Artists")
                                        .font(.custom("Nunito-ExtraBold", size: 22))
                                    Spacer()
                                }
                                ScrollView(.horizontal) {
                                    HStack(spacing: 15) {
                                        ForEach(artists.sorted(by: {$0.0 < $1.0}), id: \.key) {name, image in
                                            NavigationLink {
                                                ArtistCard(artist: name, artistImage: image)
                                            } label: {
                                                ArtistColumn(artist: name, artistImage: image)
                                                    .foregroundColor(Color("text-color"))
                                            }
                                        }
                                    }
                                    
                                }
                                .scrollIndicators(.hidden)
                                .padding(.bottom)
                            }
                            
                            // MARK: ALL CATEGORIES
                            if showAll || showCategoryOnly {
                                HStack {
                                    Text("Browse all")
                                        .font(.custom("Nunito-Bold", size: 18))
                                    Spacer()
                                }
                                LazyVGrid(columns: Array(repeating: GridItem(), count: columns)) {
                                    ForEach(categories, id: \.self) {category in
                                        let colorIndex = (category.id - 1) % 10
                                        NavigationLink {
                                            CategoryCard(category: category, bgColor: colors[colorIndex])
                                        } label: {
                                            CategoryRow(category: category, bgColor: colors[colorIndex])
                                                .foregroundColor(Color("text-color"))
                                        }
                                        
                                    }
                                }
                            }
                            
                        } // VStack
                        .padding()
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .environment(\.colorScheme, isDark ? .dark : .light) // modify the color sheme based on the state variable
        .onAppear {
            setShowAll()
            getAttributes()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(isDark: .constant(false))
            .environmentObject(SongViewModel())
    }
}
