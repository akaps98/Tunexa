//
//  ArtistCard.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 17/09/2023.
//

import SwiftUI

struct ArtistCard: View {
    let artist: Artist
    @State var artistList: [Song] = []
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode> // Store the presented value when the view is navigated
    
    // MARK: FILTER SONG BASED ON ARTIST
    func filterSong() {
        for song in songs {
            if song.author.lowercased() == artist.name.lowercased() {
                artistList.append(song)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ZStack {
                        artist.avatar
                            .resizable()
                            .scaledToFit()
                        Text(artist.name)
                            .foregroundColor(.white)
                            .font(.custom("Nunito-Black", size: 40))
                            .multilineTextAlignment(.center)
                            .offset(y: 150)
                    }
                    
                    HStack {
                        Text("Songs")
                            .foregroundColor(Color("text-color"))
                            .font(.custom("Nunito-Bold", size: 25))
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    VStack {
                        ForEach(artistList, id: \.self) {song in
                            SongRow(song: song)
                        }
                    }
                    .padding(.bottom, 100)
                    
                }
                
            }
            .edgesIgnoringSafeArea(.all)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        // Remove the current view and return to the previous view
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left.circle.fill")
                            .foregroundColor(Color("dark-gray"))
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
        .onAppear {
            filterSong()
        }
    }
}

struct ArtistCard_Previews: PreviewProvider {
    static var previews: some View {
        ArtistCard(artist: artists[5])
    }
}
