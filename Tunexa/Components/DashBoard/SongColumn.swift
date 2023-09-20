//
//  SongColumn.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 13/09/2023.
//

import SwiftUI

struct SongColumn: View {
    var song: Song
    @State var isFavourite: Bool = false
    
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
                Text(song.author[0] ?? "")
                    .font(.custom("Nunito-Regular", size: 12))
            }
        }
        .frame(width: 160)
        .onAppear {
//            isFavourite = song.isFavorite
        }
    }
}

//struct SongColumn_Previews: PreviewProvider {
//    static var previews: some View {
//        SongColumn(song: songs[2])
//    }
//}
