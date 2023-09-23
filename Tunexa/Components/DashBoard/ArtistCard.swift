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
  Created date: 17/09/2023
  Last modified: 17/09/2023
  Acknowledgement: None
  -
*/

import SwiftUI

struct ArtistCard: View {
    // MARK: ***** PROPERTIES *****
    @EnvironmentObject var songViewModel: SongViewModel
    let artist: String
    let artistImage: String
    @State var artistList: [Song] = []
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode> // Store the presented value when the view is navigated
    
    /**
     Function: filter songs based on artist name
     */
    func filterSong() {
        for song in songViewModel.songs {
            if song.author[0]!.lowercased() == artist.lowercased() {
                artistList.append(song)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    // MARK: ARTIST BANNER
                    ZStack {
                        // MARK: ARTIST IMAGE
                        AsyncImage(url: URL(string: artistImage)){ phase in
                            if let image = phase.image{
                                image
                                    .resizable()
                                    .scaledToFit()
                            }else if phase.error != nil{
                                Rectangle()
                                    .scaledToFit()
                            }else{
                                Rectangle()
                                    .scaledToFit()
                            }
                        }
                        // MARK: ARTIST NAME
                        Text(artist)
                            .foregroundColor(.white)
                            .font(.custom("Nunito-Black", size: 40))
                            .multilineTextAlignment(.center)
                            .offset(y: 150)
                    }
                    // MARK: HEADLINE
                    HStack {
                        Text("Songs")
                            .foregroundColor(Color("text-color"))
                            .font(.custom("Nunito-Bold", size: 25))
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // MARK: SONG LIST
                    VStack {
                        ForEach(artistList, id: \.self) {song in
                            SongRow(song: song)
                        }
                    }
                    .padding(.bottom, 100)
                    
                }
                
            }
            .edgesIgnoringSafeArea(.all)
            // MARK: BACK BUTTON
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        // Remove the current view and return to the previous view
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left.circle.fill")
                            .foregroundColor(Color("dark-gray"))
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
        .onAppear {
            filterSong()
        }
    }
}

struct ArtistCard_Previews: PreviewProvider {
    static var previews: some View {
        ArtistCard(artist: "Charlie Puth", artistImage: "")
            .environmentObject(SongViewModel())
    }
}
