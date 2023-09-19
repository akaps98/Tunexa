//
//  SongRow.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 19/09/2023.
//

import SwiftUI

struct SongRow: View {
    let song: Song
    @State var isFavourite = false
    
    var body: some View {
        HStack(alignment: .center) {
            // MARK: SONG IMAGE
            song.avatar
                .resizable()
                .scaledToFit()
                .frame(width: 80)
                .padding(.trailing, 10)
            VStack(alignment: .leading) {
                // MARK: SONG INFO
                VStack(alignment: .listRowSeparatorLeading) {
                    Text(song.name)
                        .font(.custom("Nunito-Bold", size: 18))
                        .lineLimit(1)
                    Text(song.author)
                        .font(.custom("Nunito-Regular", size: 14))
                    Rating(rating: song.rating)
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
                isFavourite.toggle()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 35, height: 35)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8).stroke(Color("primary-color"), lineWidth: 1)
                        )
                    Image(systemName: isFavourite ? "heart.fill" : "heart")
                }
            }
            .padding(.trailing, 5)
            
            // MARK: OPTION BUTTON
            Image(systemName: "ellipsis")
                .font(.system(size: 25))
                .foregroundColor(Color("text-color"))
        }
        .padding(.horizontal)
        
        
    }
}

struct SongRow_Previews: PreviewProvider {
    static var previews: some View {
        SongRow(song: songs[1])
    }
}
