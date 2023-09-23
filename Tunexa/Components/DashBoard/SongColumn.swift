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
  4. Christina Yoo (s3938331)
  5. Nguyen Hoang Viet (s3926104)
  Created date: 13/09/2023
  Last modified: 13/09/2023
  Acknowledgement: None
*/

import SwiftUI

struct SongColumn: View {
    // MARK: ***** PROPERTIES *****
    var song: Song
    
    var body: some View {
        VStack(alignment: .listRowSeparatorLeading) {
            // MARK: SONG IMAGE
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
            
            // MARK: SONG INFO
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
    }
}
