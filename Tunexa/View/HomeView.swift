/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Team: Squad 21 (Group 21)
  Members:
  1. Nguyen Anh Duy (s3878141) - Main Contributor
  2. Seoungjoon Hong (s3726123) - Main Contributor
  3. Junsik Kang (s3916884)
  4. Christina Yoo (s3938331)
  5. Nguyen Hoang Viet (s3926104)
  Created date: 12/09/2023
  Last modified: 22/09/2023
  Acknowledgement:
  - Horizontal Scroll View: https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-horizontal-and-vertical-scrolling-using-scrollview
  - LazyVGrid: Swift Playgrounds - Organize with Grid
*/


import SwiftUI

struct HomeView: View {
    // MARK: ***** PROPERTIES *****
    let colors : [Color] = [.red, .orange, .blue, .green, .cyan, .indigo, .pink, .yellow, .brown, .teal] // Colors for category cards
    let columns = 2 // # columns for category alignment in vertical grid
    @Binding var isDark: Bool // dark theme indicator
    @AppStorage("isAdmin") var isAdmin: Bool = false // check if user is admin
    
    // Checking filter status to display songs, artists, and categories accordingly
    @State var showAll = true
    @State var showMusicOnly = false
    @State var showCategoryOnly = false
    @State var showArtistOnly = false
    
    @EnvironmentObject var songViewModel: SongViewModel
    @State private var artists: [String: String] = [:] // Fetch artist dictionary from database
    
    /**
     Function: Set showing status for all songs, artists, and categories
     */
    func setShowAll() {
        if !showMusicOnly && !showArtistOnly && !showCategoryOnly {
            showAll = true
        } else {
            showAll = false
        }
    }
    
    /**
     Function: Get the artist data
     */
    func getAttributes(){
        artists = [:]
        for song in songViewModel.songs{
            artists[song.author[0]!] = song.author[1] ?? ""
        }
    }
    
    /**
     Function: refresh function
     */
    func refreshData(){
        setShowAll()
        getAttributes()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: ----- BACKGROUND -----
                Color("bg-color")
                    .edgesIgnoringSafeArea(.all)
                
                // MARK: ----- CONTENT -----
                ScrollView {
                    VStack {
                        HStack {
                            // MARK: HEADER
                            Text("Welcome to Tunexa")
                                .modifier(NavigationHeaderModifier())
                            Spacer()
                            // MARK: HEADER BUTTONS
                            HStack(spacing: 10) {
                                // MARK: ADMIN DASHBOARD BUTTON
                                // display the gear button only if the user is Admin
                                if isAdmin {
                                    NavigationLink {
                                        AdminDashboardView(onEdit: {refreshData()})
                                    } label: {
                                        Image(systemName: "gearshape")
                                            .font(.system(size: 20))
                                            .foregroundColor(Color("text-color"))
                                    }
                                }
                                // MARK: DARK THEME TOGGLE BUTTON
                                Button {
                                    isDark.toggle()
                                    UITabBar.appearance().backgroundColor = UIColor(Color("bg-color"))
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
                        // MARK: FILTER BUTTONS
                        HStack {
                            // SONG BUTTON
                            Button {
                                showMusicOnly.toggle() // Show song data only
                                showArtistOnly = false
                                showCategoryOnly = false
                                setShowAll()
                            } label: {
                                FilterCapsule(buttonName: "Music", show: showMusicOnly)
                            }
                            
                            // ARTIST BUTTON
                            Button {
                                showArtistOnly.toggle() // Show artist data only
                                showMusicOnly = false
                                showCategoryOnly = false
                                setShowAll()
                            } label: {
                                FilterCapsule(buttonName: "Artist", show: showArtistOnly)
                            }
                            
                            // CATEGORY BUTTON
                            Button {
                                showCategoryOnly.toggle() // Show category data only
                                showArtistOnly = false
                                showMusicOnly = false
                                setShowAll()
                            } label: {
                                FilterCapsule(buttonName: "Categories", show: showCategoryOnly)
                                
                            }
                            
                            Spacer()
                            
                        }
                        .offset(y: -8)
                        
                        // MARK: ALL SONGS
                        if showAll || showMusicOnly {
                            HStack {
                                Text("All Songs")
                                    .modifier(TextHeaderModifier())
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
                            .scrollIndicators(.hidden) // hide scroll bar
                            .padding(.bottom)
                        }
                        
                        
                        // MARK: ALL ARTISTS
                        if showAll || showArtistOnly {
                            HStack {
                                Text("All Artists")
                                    .modifier(TextHeaderModifier())
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
                            .scrollIndicators(.hidden) // hide scroll bar
                            .padding(.bottom)
                        }
                        
                        // MARK: ALL CATEGORIES
                        if showAll || showCategoryOnly {
                            HStack {
                                Text("Browse Categories")
                                    .modifier(TextHeaderModifier())
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
                    } // ScrollView
                    .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .environment(\.colorScheme, isDark ? .dark : .light) // modify the color sheme based on the state variable
        .onAppear {
            // Show all song data retrieved from database and get artists information
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
