//
//  SongRow.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 12/09/2023.
//

import SwiftUI

struct SongRow: View {
    var body: some View {
        
        HStack(alignment: .center) {
            // MARK: SONG IMAGE
            Image("song-avatar-1")
                .resizable()
                .scaledToFit()
                .frame(width: 80)
                .padding(.trailing, 15)
            VStack(alignment: .listRowSeparatorLeading) {
                // MARK: SONG INFO
                VStack(alignment: .listRowSeparatorLeading) {
                    Text("See You Again")
                        .font(.custom("Nunito-Bold", size: 18))
                    Text("Charlie Puth")
                        .font(.custom("Nunito-Regular", size: 16))
                }
                // MARK: SONG CATEGORIES
                HStack {
                    Capsule()
                        .frame(width: 100, height: 25)
                        .foregroundColor(Color("secondary-color"))
                        .overlay(
                            Text("Pop")
                                .foregroundColor(.white)
                                .font(.custom("Nunito-Medium", size: 16))
                        )
                    Capsule()
                        .frame(width: 100, height: 25)
                        .foregroundColor(Color("secondary-color"))
                        .overlay(
                            Text("Chill")
                                .foregroundColor(.white)
                                .font(.custom("Nunito-Medium", size: 16))
                        )
                }
                .offset(y: -2)
            }
            Spacer()
            
            Image(systemName: "ellipsis")
                .font(.system(size: 25))
                .foregroundColor(Color("text-color"))
        }
        .padding(.horizontal)
        
        
    }
}

struct SongRow_Previews: PreviewProvider {
    static var previews: some View {
        SongRow()
    }
}
