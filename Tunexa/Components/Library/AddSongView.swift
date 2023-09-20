//
//  AddSongView.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 17/09/2023.
//

import SwiftUI

struct AddSongView: View {
    @EnvironmentObject var songViewModel: SongViewModel
    @Binding var isDark: Bool
    
    var body: some View {
        ZStack {
            // MARK: BACKGROUND
            Color("bg-color")
            
            ScrollView {
                VStack {
                    RoundedRectangle(cornerRadius: 5)
                        .edgesIgnoringSafeArea(.all)
                        .frame(height: 200)
                        .foregroundColor(Color("secondary-color"))
                        .overlay {
                            Text("Add to this playlist")
                                .font(.custom("Nunito-Bold", size: 25))
                                .foregroundColor(Color("text-color"))
                        }
                    
                    
                    VStack {
                        HStack {
                            Text("Available Songs")
                                .font(.custom("Nunito-ExtraBold", size: 22))
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        ForEach(songViewModel.songs, id: \.id) {song in
                            AddSongRow(song: song, isAdded: false)
                        }
                    }
                        
                        
                        
                    
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .environment(\.colorScheme, isDark ? .dark : .light) // modify the color sheme based on the state variable
    }
}

struct AddSongView_Previews: PreviewProvider {
    static var previews: some View {
        AddSongView(isDark: .constant(true))
    }
}
