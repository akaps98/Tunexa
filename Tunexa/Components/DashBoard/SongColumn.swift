//
//  SongColumn.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 13/09/2023.
//

import SwiftUI

struct SongColumn: View {
    var body: some View {
        VStack(alignment: .listRowSeparatorLeading) {
            Image("song-avatar-1")
                .resizable()
                .scaledToFit()
            
            VStack(alignment: .listRowSeparatorLeading) {
                Text("See You Again")
                    .font(.custom("Nunito-Bold", size: 18))
                Text("Charlie Puth")
                    .font(.custom("Nunito-Regular", size: 16))
            }
        }
        .frame(width: 160)
    }
}

struct SongColumn_Previews: PreviewProvider {
    static var previews: some View {
        SongColumn()
    }
}
