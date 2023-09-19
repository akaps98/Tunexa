//
//  SearchView.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 13/09/2023.
//

import SwiftUI

struct SearchView: View {
    @Binding var isDark: Bool
    @State private var name: String = ""
    @State private var ratingValue = 1.0
    @State private var filteredSongs: [Song] = songs
    @State private var showOnlyFavorites: Bool = false
    var minimumValue = 1.0
    var maximumValue = 5.0
        
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: -----BACKGROUND-----
                Color("bg-color")
                    .edgesIgnoringSafeArea(.all)
                // MARK: -----CONTENT-----
                ScrollView {
                    HStack(spacing: 20) {
                        VStack {
                            // MARK: -----STAR RATING SLIDER-----
                            Slider(value: $ratingValue, in: minimumValue...maximumValue)
                                .frame(width: 250)
                            Text("Rating: \(Int(ratingValue))")
                                .font(.custom("Nunito-Medium", size: 16))
                                .offset(y: -10)
                        }
                        Button(action: {
                            showOnlyFavorites.toggle()
                            filterSongs(with: name)
                        }) {
                            Image(systemName: showOnlyFavorites ? "heart.fill" : "heart")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .padding(10)
                                .background(Color("bg-color"))
                                .clipShape(Circle())
                        }
                        .padding(.bottom, 30)
                    }

                    
                    // MARK: BODY
                    VStack {
                        ForEach(filteredSongs, id: \.self) { song in
                            SongRow(song: song)
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
                        
                    }
                    
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
            filteredSongs = songs
        }
        .navigationBarTitleDisplayMode(.inline)
        .environment(\.colorScheme, isDark ? .dark : .light) // modify the color sheme based on the state variable
    }
    
    func filterSongs(with term: String) {
        filteredSongs = songs.filter { song in
            let matchesName = term.isEmpty || song.name.lowercased().contains(term.lowercased())
            let matchesRating = song.rating >= Int(ratingValue)
            let matchesFavorite = !showOnlyFavorites || song.isFavorite
            return matchesName && matchesRating && matchesFavorite
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(isDark: .constant(false))
    }
}
