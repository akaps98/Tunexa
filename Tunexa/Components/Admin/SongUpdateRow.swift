//
//  SongUpdateRow.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 22/09/2023.
//

import SwiftUI

struct SongUpdateRow: View {
    let song: Song
    @State var showDeleteAlert = false
    @EnvironmentObject var songViewModel: SongViewModel
    
    var body: some View {
        ZStack {
            VStack {
                Divider()
                    .frame(height: 1)
                    .background(Color("secondary-color"))
                HStack {
                    VStack(alignment: .leading) {
                        // MARK: SONG INFO
                        VStack(alignment: .listRowSeparatorLeading) {
                            VStack(alignment: .listRowSeparatorLeading) {
                                Text(song.name ?? "")
                                    .font(.custom("Nunito-Bold", size: 22))
                                    .foregroundColor(Color("text-color"))
                                    .lineLimit(1)
                                Text(song.author[0] ?? "")
                                    .font(.custom("Nunito-Regular", size: 16))
                                    .foregroundColor(Color("text-color"))
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
                    
                    Button {
                        showDeleteAlert.toggle()
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.red)
                    }
                }
                .padding([.horizontal, .bottom])
                
                
                // MARK: AVATARS DISPLAY
                HStack {
                    // MARK: SONG AVATAR DISPLAY
                    VStack {
                        AsyncImage(url: URL(string: song.avatarName ?? "")){ phase in
                            if let i = phase.image{
                                i
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)
                                    .cornerRadius(5)
                                    .padding(.trailing, 10)
                            }else if phase.error != nil{
                                Rectangle()
                                    .frame(width: 120, height: 120)
                            }else{
                                Rectangle()
                                    .frame(width: 120, height: 120)
                            }
                        }
                        Text("Song Avatar")
                            .font(.custom("Nunito-SemiBold", size: 16))
                            .foregroundColor(Color("text-color"))
                    }
                    
                    // MARK: ARTIST AVATAR DISPLAY
                    VStack {
                        AsyncImage(url: URL(string: song.author[1] ?? "")){ phase in
                            if let i = phase.image{
                                i
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .frame(width: 120, height: 120)
                            }else if phase.error != nil{
                                Rectangle()
                                    .frame(width: 120, height: 120)
                            }else{
                                Rectangle()
                                    .frame(width: 120, height: 120)
                            }
                        }
                        Text("Artist Avatar")
                            .font(.custom("Nunito-SemiBold", size: 16))
                            .foregroundColor(Color("text-color"))
                    }
                }
               
            }
            
            if showDeleteAlert {
                ZStack {
                    Color(.white)
                        .opacity(0.1)
                        .edgesIgnoringSafeArea(.all)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 350, height: 140)
                            .foregroundColor(Color(.white).opacity(1))
                            .overlay {
                                RoundedRectangle(cornerRadius: 8).stroke(Color("secondary-color"), lineWidth: 3)
                            }
                        VStack {
                            Text("Do you want to delete this song?")
                                .font(.custom("Nunito-Bold", size: 20))
                            
                            HStack {
                                Button {
                                    songViewModel.deleteSongData(id: song.id!, name: song.name!, author: song.author[0]!)
                                } label: {
                                    Text("Yes")
                                         .foregroundColor(.white)
                                         .font(.custom("Nunito-Bold", size: 22))
                                         .padding(.horizontal, 20)
                                         .padding(.vertical, 10)
                                         .background(
                                             RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(.green)
                                         )
                                }
                                
                                Button {
                                    showDeleteAlert = false
                                } label: {
                                    Text("No")
                                        .foregroundColor(.white)
                                        .font(.custom("Nunito-Bold", size: 22))
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(.red)
                                        )
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
    }
}
