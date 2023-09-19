//
//  AddSongRow.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 17/09/2023.
//

import SwiftUI

struct AddSongRow: View {
    let song: Song
    let isAdded : Bool
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
            if !isAdded {
                Button {
                    print("add")
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 25))
                        .foregroundColor(Color("primary-color"))
                }
                .padding(.trailing, 5)
            } else {
                // MARK: DELETE BUTTON
                Button {
                    print("delete")
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

struct AddSongRow_Previews: PreviewProvider {
    static var previews: some View {
        AddSongRow(song: songs[2], isAdded: false)
    }
}
