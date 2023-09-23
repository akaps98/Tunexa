//
//  SearchView.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 13/09/2023.
//

import SwiftUI
import FirebaseAuth

struct SearchView: View {
    @AppStorage("uid") var isLoggedIn: Bool = Auth.auth().currentUser != nil
    @EnvironmentObject var songViewModel: SongViewModel
    @Binding var isDark: Bool
    @State private var name: String = ""
    @State private var ratingValue = 1.0
    @State private var filteredSongs: [Song] = []
    @State private var showOnlyFavorites: Bool = false
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
                                    favoiteSongs()
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
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8).stroke(Color("secondary-color"), lineWidth: 2)
                    )
                    
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
                        .font(.custom("Nunito-ExtraBold", size: 25))
                }
            }
           
        }
        .searchable(text: $name)
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
//            let matchesFavorite = !showOnlyFavorites || song.isFavorite
            return matchesName && matchesRating
        }
    }
    
    // filter the songs by the fetched favorite list
    func favoiteSongs() {
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
