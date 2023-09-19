//
//  ArtistColumn.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 13/09/2023.
//

import SwiftUI

struct ArtistColumn: View {
    let artist: String
    let artistImage: String
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: artistImage)){ phase in
                if let image = phase.image{
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                }else if phase.error != nil{
                    Circle()
                        .frame(width: 200)
                }else{
                    Circle()
                        .frame(width: 200)
                }
            }
            VStack {
                Text(artist)
                    .font(.custom("Nunito-Bold", size: 20))
            }
        }
        .frame(width: 180)
        
        
    }
}

//struct ArtistColumn_Previews: PreviewProvider {
//    static var previews: some View {
//        ArtistColumn(artist: artists[2])
//    }
//}
