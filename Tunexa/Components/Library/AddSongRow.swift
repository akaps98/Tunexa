/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Team: Squad 21 (Group 21)
  Members:
  1. Nguyen Anh Duy (s3878141) - Main Contributor
  2. Seoungjoon Hong (s3726123)
  3. Junsik Kang (s3916884)
  4. Christina Yoo (s3938331) - Main Contributor
  5. Nguyen Hoang Viet (s3926104)
  Created date: 17/09/2023
  Last modified: 20/09/2023
  Acknowledgement:
*/

import SwiftUI

struct AddSongRow: View {
    // MARK: ***** PROPERTIES *****
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
                        CategoryCapsule(categoryName: category)
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
