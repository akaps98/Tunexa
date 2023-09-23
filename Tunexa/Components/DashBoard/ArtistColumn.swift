/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Team: Squad 21 (Group 21)
  Members:
  1. Nguyen Anh Duy (s3878141) - Main Contributor
  2. Seoungjoon Hong (s3726123) - Sub Contributor
  3. Junsik Kang (s3916884)
  4. Christina Yoo (s3938331)
  5. Nguyen Hoang Viet (s3926104)
  Created date: 13/09/2023
  Last modified: 13/09/2023
  Acknowledgement: None
  -
*/

import SwiftUI

struct ArtistColumn: View {
    let artist: String
    let artistImage: String
    var body: some View {
        VStack {
            // MARK: ARTIST IMAGE
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
                // MARK: ARTIST NAME
                Text(artist)
                    .font(.custom("Nunito-Bold", size: 20))
            }
        }
        .frame(width: 180)
        
        
    }
}

struct ArtistColumn_Previews: PreviewProvider {
    static var previews: some View {
        ArtistColumn(artist: "Charlie Puth", artistImage: "")
            .environmentObject(SongViewModel())
    }
}
