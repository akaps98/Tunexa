//
//  AddSongView.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 17/09/2023.
//

import SwiftUI

struct AddSongView: View {
    var body: some View {
        ScrollView {
            VStack {
                RoundedRectangle(cornerRadius: 5)
                    .edgesIgnoringSafeArea(.all)
                    .frame(height: 200)
                    .foregroundColor(Color("secondary-color"))
                    .overlay {
                        Text("Add to this playlist")
                            .font(.custom("Nunito-Bold", size: 35))
                            .foregroundColor(Color("text-color"))
                    }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("light-gray"))
                    
                    VStack {
                        HStack {
                            Text("Suggested Songs")
                                .font(.custom("Nunito-Bold", size: 22))
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        ForEach(songs, id: \.self) {song in
                            AddSongRow(song: song, isAdded: false)
                        }
                    }
                    
                    
                    
                }
                .padding()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct AddSongView_Previews: PreviewProvider {
    static var previews: some View {
        AddSongView()
    }
}
