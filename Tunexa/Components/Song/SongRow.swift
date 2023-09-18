//
//  SongRow.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 12/09/2023.
//

import SwiftUI

struct SongRow: View {
    let song: Song
    @State var favorite: [String] = []
    @State var isFavorite: Bool = false
    
    func fetch() {
        User.fetch { result in
            switch result {
            case .success(let fetchedUser):
                favorite = fetchedUser.favorite
                if favorite.contains(song.id ?? "") {
                    isFavorite = true
                } else {
                    isFavorite = false
                }
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
                    Text(song.author ?? "")
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
            
            // MARK: HEART BUTTON
            Button {
                if let songId = song.id {
                    if favorite.contains(songId) {
                        User.deleteFromFavorite(songID: songId) { error in
                            if let error = error {
                                print("Error removing from favorite: \(error.localizedDescription)")
                            } else {
                                print("Removed from favorite successfully.")
                                fetch()
                            }
                        }
                    } else {
                        User.addToFavorite(songID: songId) { error in
                            if let error = error {
                                print("Error adding to favorite: \(error.localizedDescription)")
                            } else {
                                print("Added to favorite successfully.")
                                fetch()
                            }
                        }
                    }
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 35, height: 35)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8).stroke(Color("primary-color"), lineWidth: 1)
                        )
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                }
            }
            .padding(.trailing, 5)
            
            // MARK: OPTION BUTTON
            Image(systemName: "ellipsis")
                .font(.system(size: 25))
                .foregroundColor(Color("text-color"))
        }
        .padding(.horizontal)
        .onAppear {
            fetch()
        }
        
        
    }
}

