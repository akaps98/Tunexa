//
//  ArtistCard.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 17/09/2023.
//

import SwiftUI

struct ArtistCard: View {
    @EnvironmentObject var songViewModel: SongViewModel
    let artist: Artist
    @State var artistList: [Song] = []
    
    // MARK: FILTER SONG BASED ON ARTIST
    func filterSong() {
        artistList = []
        for song in songViewModel.songs {
            if song.author!.lowercased() == artist.name.lowercased() {
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
                    
                    ForEach(artistList, id: \.id) {song in
                        SongRow(song: song)
                    }
                    
                }
                
            }
            .edgesIgnoringSafeArea(.all)
        }
        .onAppear {
            filterSong()
        }
    }
}

struct ArtistCard_Previews: PreviewProvider {
    static var previews: some View {
        ArtistCard(artist: artists[5])
            .environmentObject(SongViewModel())
    }
}
