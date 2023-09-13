//
//  ArtistColumn.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 13/09/2023.
//

import SwiftUI

struct ArtistColumn: View {
    var body: some View {
        VStack {
            Image("song-avatar-1")
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
            
            VStack {
                Text("Charlie Puth")
                    .font(.custom("Nunito-Bold", size: 20))
                Text("Song Writer")
                    .font(.custom("Nunito-Regular", size: 16))
            }
        }
        .frame(width: 180)
        
        
    }
}

struct ArtistColumn_Previews: PreviewProvider {
    static var previews: some View {
        ArtistColumn()
    }
}
