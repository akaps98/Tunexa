//
//  SongColumn.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 13/09/2023.
//

import SwiftUI

struct SongColumn: View {
    let song: Song
    
    var body: some View {
        VStack(alignment: .listRowSeparatorLeading) {
            song.avatar
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .listRowSeparatorLeading) {
                Text(song.name)
                    .font(.custom("Nunito-Bold", size: 15))
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(1)
                Text(song.author)
                    .font(.custom("Nunito-Regular", size: 12))
            }
        }
        .frame(width: 160)
    }
}

struct SongColumn_Previews: PreviewProvider {
    static var previews: some View {
        SongColumn(song: songs[2])
    }
}
