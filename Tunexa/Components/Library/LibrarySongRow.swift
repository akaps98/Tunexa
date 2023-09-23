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

struct LibrarySongRow: View {
    // MARK: ***** PROPERTIES *****
    let song: Song
    @Binding var editMode: Bool
    
    // for updating the library view upon delete button click
    var onDelete: (() -> Void)?
    
    var body: some View {
        HStack(alignment: .center) {
            // MARK: SONG IMAGE
            AsyncImage(url: URL(string: song.avatarName ?? "")){ phase in
                if let i = phase.image{
                    i
                        .resizable()
                        .scaledToFit()
                        .frame(height: 90)
                        .padding(.trailing, 15)
                }else if phase.error != nil{
                    Rectangle()
                        .scaledToFit()
                        .frame(height: 90)
                        .padding(.trailing, 15)
                }else{
                    Rectangle()
                        .scaledToFit()
                        .frame(height: 90)
                        .padding(.trailing, 15)
                }
            }
                
            VStack(alignment: .leading) {
                // MARK: SONG INFO
                VStack(alignment: .listRowSeparatorLeading) {
                    VStack(alignment: .listRowSeparatorLeading) {
                        Text(song.name ?? "")
                            .font(.custom("Nunito-Bold", size: 18))
                            .foregroundColor(Color("text-color"))
                            .lineLimit(1)
                        Text(song.author[0] ?? "")
                            .font(.custom("Nunito-Regular", size: 14))
                            .foregroundColor(Color("text-color"))
                    }
                    .padding(.bottom, 2)
                    
                }
                // MARK: SONG CATEGORIES
                HStack {
                    ForEach(song.categories, id: \.self) {category in
                        CategoryCapsule(categoryName: category)
                    }
                    Spacer()
                }
                .padding(.top, 5)
            }
            Spacer()
            
            // MARK: DELETE BUTTON
            // if in edit mode, display the delete button to delete the song from the playlist
            if editMode {
                Button {
                    if let songId = song.id {
                        User.deleteFromPlaylist(songID: songId) { error in
                            if let error = error {
                                print("Error deleting from playlist: \(error.localizedDescription)")
                            } else {
                                print("Deleted from playlist successfully.")
                                // trigger update in the library view
                                onDelete?()
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
        .padding(.horizontal)
        
    }
}

