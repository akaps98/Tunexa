//
//  AddSongRow.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 17/09/2023.
//

import SwiftUI

struct AddSongRow: View {
    let song: Song
    
    // fetch the user's saved playlist from firebase
    @State var playlist: [String] = []
    func getPlaylist() {
        User.fetch { result in
            switch result {
            case .success(let fetchedUser):
                playlist = fetchedUser.playlist
            case .failure(let error):
                print("Error fetching user data: \(error)")
            }
        }
    }
    
    var body: some View {
        HStack(alignment: .center) {
            // MARK: SONG IMAGE
            AsyncImage(url: URL(string: song.avatarName ?? "")){ phase in
                if let i = phase.image{
                    i
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80)
                        .padding(.trailing, 10)
                }else if phase.error != nil{
                    Rectangle()
                        .frame(width: 80)
                        .padding(.trailing, 10)
                }else{
                    Rectangle()
                        .frame(width: 80)
                        .padding(.trailing, 10)
                }
            }
            VStack(alignment: .leading) {
                // MARK: SONG INFO
                VStack(alignment: .listRowSeparatorLeading) {
                    Text(song.name ?? "")
                        .font(.custom("Nunito-Bold", size: 18))
                        .lineLimit(1)
                    Text(song.author[0] ?? "")
                        .font(.custom("Nunito-Regular", size: 14))
                }
                // MARK: SONG CATEGORIES
                HStack {
                    ForEach(song.categories, id: \.self) {category in
                        Text(category).textCase(.uppercase)
                            .foregroundColor(.white)
                            .font(.custom("Nunito-Medium", size: 12))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 2)
                            .background(Color("secondary-color"), in: Capsule())
                    }
                    Spacer()
                }
            }
            Spacer()
            
            // MARK: ADD BUTTON
            if let songId = song.id {
                // if playlist does not contain the song, display the add button to add the song to the user's playlist
                if !playlist.contains(songId) {
                    Button {
                        User.addToPlaylist(songID: songId) { error in
                            if let error = error {
                                print("Error adding to playlist: \(error.localizedDescription)")
                            } else {
                                print("Added to playlist successfully.")
                                // update the playlist
                                getPlaylist()
                            }
                        }
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 25))
                            .foregroundColor(Color("third-color"))
                    }
                    .padding(.trailing, 5)
                } else {
                    // MARK: DELETE BUTTON
                    // if playlist contains the song, display the delete button to delete the song from the user's playlist
                    Button {
                        if let songId = song.id {
                            User.deleteFromPlaylist(songID: songId) { error in
                                if let error = error {
                                    print("Error deleting from playlist: \(error.localizedDescription)")
                                } else {
                                    print("Deleted from playlist successfully.")
                                    // update the playlist
                                    getPlaylist()
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "minus.circle")
                            .font(.system(size: 25))
                            .foregroundColor(Color("primary-color"))
                    }
                    .padding(.trailing, 5)
                }
            }
        }
        .padding(.horizontal)
        .onAppear {
            getPlaylist()
        }
        
    }
}
