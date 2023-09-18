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
            AsyncImage(url: URL(string: song.avatarName ?? "")){ phase in
                if let i = phase.image{
                    i
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }else if phase.error != nil{
                    Rectangle()
                        .scaledToFit()
                        .frame(width: 80)
                        .padding(.trailing, 10)
                }else{
                    Rectangle()
                        .scaledToFit()
                        .frame(width: 80)
                        .padding(.trailing, 10)
                }
            }
            
            VStack(alignment: .listRowSeparatorLeading) {
                Text(song.name ?? "")
                    .font(.custom("Nunito-Bold", size: 15))
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(1)
                Text(song.author ?? "")
                    .font(.custom("Nunito-Regular", size: 12))
            }
        }
        .frame(width: 160)
    }
}
