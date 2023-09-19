//
//  ArtistColumn.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 13/09/2023.
//

import SwiftUI

struct ArtistColumn: View {
    let artist: Artist
    var body: some View {
        VStack {
            artist.avatar
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
            
            VStack {
                Text(artist.name)
                    .font(.custom("Nunito-Bold", size: 20))
                Text(artist.job)
                    .font(.custom("Nunito-Regular", size: 16))
            }
        }
        .frame(width: 180)
        
        
    }
}

struct ArtistColumn_Previews: PreviewProvider {
    static var previews: some View {
        ArtistColumn(artist: artists[2])
    }
}
