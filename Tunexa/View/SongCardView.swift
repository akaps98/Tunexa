//
//  SongCardView.swift
//  Tunexa
//
//  Created by Viet Nguyen Hoang on 13/09/2023.
//

import SwiftUI

struct SongCardView: View {
    var body: some View {
        ZStack {
            Color("bg-color")
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Hello World!")
            }
        }
    }
}

struct SongCardView_Previews: PreviewProvider {
    static var previews: some View {
        SongCardView()
    }
}
