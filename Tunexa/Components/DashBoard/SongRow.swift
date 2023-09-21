//
//  SongRow.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 12/09/2023.
//

import SwiftUI
import FirebaseAuth

struct SongRow: View {
    let song: Song
        
    @AppStorage("uid") var isLoggedIn: Bool = Auth.auth().currentUser != nil
    
    // fetch user's saved favorite list from firebase
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
    
    // for updating the search view upon favorite list edit
    var onEdit: (() -> Void)?
    
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
                            .lineLimit(1)
                        Text(song.author[0] ?? "")
                            .font(.custom("Nunito-Regular", size: 14))
                    }
                    .padding(.bottom, 2)
                    
                    // MARK: RATING
                    Rating(rating: song.rating ?? 0)
                }
                // MARK: SONG CATEGORIES
                HStack {
                    ForEach(song.categories, id: \.self) {category in
                        Text(category).textCase(.uppercase)
                            .foregroundColor(.white)
                            .font(.custom("Nunito-Medium", size: 12))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 2)
                            .background(Color("secondary-color"), in: Capsule())
                    }
                    Spacer()
                }
                .padding(.top, 5)
            }
            Spacer()
            
            // if user is logged in, display the heart button for users to add or delete from their favorite list
            if isLoggedIn {
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
                                    // trigger update in the search view
                                    onEdit?()
                                }
                            }
                        } else {
                            User.addToFavorite(songID: songId) { error in
                                if let error = error {
                                    print("Error adding to favorite: \(error.localizedDescription)")
                                } else {
                                    print("Added to favorite successfully.")
                                    fetch()
                                    // trigger update in the search view
                                    onEdit?()
                                }
                            }
                        }
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 30, height: 30)
                            .foregroundColor(.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8).stroke(Color("primary-color"), lineWidth: 1)
                            )
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                    }
                }
                .padding(.trailing, 5)
            }
        }
        .padding(.horizontal)
        .onAppear {
            // if user is logged in, fetch the favorite list on view appear
            if isLoggedIn {
                fetch()
            }
        }
        
    }
}
