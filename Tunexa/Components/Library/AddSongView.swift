/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Team: Squad 21 (Group 21)
  Members:
  1. Nguyen Anh Duy (s3878141) - Main Contributor
  2. Seoungjoon Hong (s3726123)
  3. Junsik Kang (s3916884)
  4. Christina Yoo (s3938331) - Main Contributor
  5. Nguyen Hoang Viet (s3926104)
  Created date: 17/09/2023
  Last modified: 20/09/2023
  Acknowledgement:
*/

import SwiftUI

struct AddSongView: View {
    // MARK: ***** PROPERTIES *****
    @EnvironmentObject var songViewModel: SongViewModel
    @Binding var isDark: Bool
    
    var body: some View {
        ZStack {
            // MARK: BACKGROUND
            Color("bg-color")
            
            ScrollView {
                VStack {
                    // MARK: BANNER
                    RoundedRectangle(cornerRadius: 5)
                        .edgesIgnoringSafeArea(.all)
                        .frame(height: 200)
                        .foregroundColor(Color("secondary-color"))
                        .overlay {
                            Text("Add to this playlist")
                                .font(.custom("Nunito-Bold", size: 25))
                                .foregroundColor(Color("text-color"))
                        }
                    
                    // MARK: AVAILABLE LIST OF SONGS
                    VStack {
                        HStack {
                            Text("Available Songs")
                                .font(.custom("Nunito-ExtraBold", size: 22))
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        ForEach(songViewModel.songs, id: \.id) {song in
                            AddSongRow(song: song)
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
            .environmentObject(SongViewModel())
    }
}
