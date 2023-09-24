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
  4. Christina Yoo (s3938331) - Sub Contributor
  5. Nguyen Hoang Viet (s3926104)
  Created date: 13/09/2023
  Last modified: 22/09/2023
  Acknowledgement:
  - Search bar and filter data using searchable modifier: https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-a-search-bar-to-filter-your-data
*/

import SwiftUI
import FirebaseAuth

struct SearchView: View {
    // MARK: ***** PROPERTIES *****
    @Binding var isDark: Bool
    @AppStorage("uid") var isLoggedIn: Bool = Auth.auth().currentUser != nil // check if user has logged in to the app
    
    // SONG LIST PROPERTIES
    @EnvironmentObject var songViewModel: SongViewModel
    @State private var name: String = ""
    @State private var ratingValue = 1.0
    @State private var filteredSongs: [Song] = []
    @State private var showOnlyFavorites: Bool = false
    
    // RATING PROPERTIES
    var minimumValue = 1.0
    var maximumValue = 5.0
    
    // fetch user's saved favorites from firebase
    @State var favoriteList: [String] = []
    func fetchFavorites() {
        User.fetch { result in
            switch result {
            case .success(let fetchedUser):
                favoriteList = fetchedUser.favorite
            case .failure(let error):
                print("Error fetching user data: \(error)")
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: -----BACKGROUND-----
                Color("bg-color")
                    .edgesIgnoringSafeArea(.all)
                
                // MARK: -----CONTENT-----
                ScrollView {
                    HStack(alignment: .center, spacing: 20) {
                        VStack(alignment: .listRowSeparatorLeading) {
                            // MARK: -----STAR RATING SLIDER-----
                            Slider(value: $ratingValue, in: minimumValue...maximumValue)
                                .frame(width: 250)
                            Text("Rating: \(Int(ratingValue))")
                                .font(.custom("Nunito-Bold", size: 18))
                                .offset(y: -5)
                        }
                        
                        Spacer()
                        
                        if isLoggedIn {
                            // if user is logged in, display the heart filtering option
                            Button(action: {
                                showOnlyFavorites.toggle()
                                if showOnlyFavorites {
                                    favoriteSongs()
                                } else {
                                    filterSongs(with: name)
                                }
                            }) {
                                Image(systemName: showOnlyFavorites ? "heart.fill" : "heart")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .padding(10)
                                    .background(Color("bg-color"))
                                    .clipShape(Circle())
                                    .offset(y: -12)
                            }
                        }
                        
                    }
                    .padding()
                    .frame(width: 360)
                    .modifier(RoundedBorderModifier())
                    
                    // MARK: BODY
                    VStack {
                        ForEach(filteredSongs, id: \.self) { song in
                            NavigationLink {
                                SongCard(song: song, songs: songViewModel.songs)
                            } label: {
                                SongRow(song: song, onEdit: {fetchFavorites()})
                            }
                        }
                    }
                    .padding(.top)
                }
            }
            // MARK: HEADER
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Search")
                        .modifier(NavigationHeaderModifier())
                }
            }
           
        }
        .searchable(text: $name) // Search Bar
        .onChange(of: name) { newValue in
            filterSongs(with: newValue)
        }
        .onChange(of: ratingValue) { _ in
            filterSongs(with: name)
        }
        .onAppear {
            filteredSongs = songViewModel.songs
            fetchFavorites()
        }
        .navigationBarTitleDisplayMode(.inline)
        .environment(\.colorScheme, isDark ? .dark : .light) // modify the color sheme based on the state variable
    }
    
    func filterSongs(with term: String) {
        filteredSongs = songViewModel.songs.filter { song in
            let matchesName = term.isEmpty || song.name!.lowercased().contains(term.lowercased())
            let matchesRating = song.rating ?? 1 >= Int(ratingValue)
            return matchesName && matchesRating
        }
    }
    
    // filter the songs by the fetched favorite list
    func favoriteSongs() {
        filteredSongs = songViewModel.songs.filter { song in
            return favoriteList.contains(song.id ?? "")
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(isDark: .constant(false))
            .environmentObject(SongViewModel())
    }
}
