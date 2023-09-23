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
  Created date: 13/09/2023
  Last modified: 22/09/2023
  Acknowledgement:
  - SwiftUI Sheet: https://www.hackingwithswift.com/quick-start/swiftui/how-to-present-a-new-view-using-sheets
*/

import SwiftUI
import FirebaseAuth

struct LibraryView: View {
    // MARK: ***** PROPERTIES *****
    @AppStorage("uid") var isLoggedIn: Bool = Auth.auth().currentUser != nil
    @Binding var isDark: Bool
    @State var showAddSongSheet = false
    @EnvironmentObject var songViewModel: SongViewModel
    
    @State var playlistSongs: [Song] = [] //fetch user's saved playlist from firebase
    /**
     Function:
     */
    func getSongs() {
        editMode = false
        User.fetch { result in
            switch result {
            case .success(let fetchedUser):
                let playlist = fetchedUser.playlist
                playlistSongs = songViewModel.songs.filter { song in
                    return playlist.contains(song.id ?? "")
                }
            case .failure(let error):
                print("Error fetching user data: \(error)")
            }
        }
        
    }
    
    @State var pictureName = "" //fetch user's profile image from firebase
    func getImage() {
        User.fetch { result in
            switch result {
            case .success(let fetchedUser):
                pictureName = fetchedUser.pictureName
            case .failure(let error):
                print("Error fetching user data: \(error)")
            }
        }
    }
    
    @State var editMode = false
    
    var body: some View {
        if (isLoggedIn) {
            NavigationStack {
                ZStack {
                    // MARK: BACKGROUND
                    Color("bg-color")
                        .edgesIgnoringSafeArea(.all)
                    
                    // MARK: CONTENT
                        ScrollView {
                            // MARK: LIBRARY BANNER
                            VStack {
                                Image("library-cover")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 250, height: 250)
                                
                                Text("Your Playlist")
                                    .font(.custom("Nunito-ExtraBold", size: 25))
                            }
                            .padding()
                            
                            if !playlistSongs.isEmpty {
                                HStack {
                                    HStack(spacing: 10) {
                                        // present AddSongView to add songs to the playlist
                                        Button {
                                            editMode = false
                                            showAddSongSheet.toggle()
                                        } label: {
                                            Image(systemName: "plus.circle")
                                                .font(.system(size: 25))
                                                .foregroundColor(Color("text-color"))
                                        }.sheet(isPresented: $showAddSongSheet, onDismiss: { getSongs() }) {
                                            AddSongView(isDark: $isDark)
                                                .presentationDetents([.large])
                                                .presentationDragIndicator(.visible)
                                                .environmentObject(SongViewModel())
                                        }
                                        
                                        // toggle the edit mode to display the delete button in the song row
                                        Button {
                                            editMode.toggle()
                                        } label: {
                                            Image(systemName: "slider.horizontal.3")
                                                .font(.system(size: 25))
                                                .foregroundColor(Color(!editMode ? "text-color" : "AccentColor"))
                                        }
                                        
                                    }
                                    
                                    Spacer()
                                }
                                .padding([.horizontal,.bottom])
                            }
                            
                            
                            if playlistSongs.isEmpty {
                                Text("There is nothing in your playlist yet! Ready to customize your own songs?")
                                    .font(.custom("Nunito-Regular", size: 18))
                                Button {
                                    print("Add Song clicked")
                                    showAddSongSheet.toggle()
                                } label: {
                                    Capsule()
                                        .foregroundColor(Color("primary-color"))
                                        .frame(width: 200, height: 50)
                                        .overlay {
                                            Text("Add Song")
                                                .font(.custom("Nunito-Bold", size: 18))
                                                .foregroundColor(Color("text-color"))
                                        }
                                }
                                .sheet(isPresented: $showAddSongSheet, onDismiss: { getSongs() }) {
                                    AddSongView(isDark: $isDark)
                                        .presentationDetents([.large])
                                        .presentationDragIndicator(.visible)
                                        .environmentObject(SongViewModel())
                                }
                            } else {
                                // when delete button is tapped (onDelete), the list is updated by getSongs()
                                ForEach(playlistSongs, id: \.self) { song in
                                    NavigationLink {
                                        SongCard(song: song, songs: playlistSongs)
                                    } label: {
                                        LibrarySongRow(song: song, editMode: $editMode, onDelete: {getSongs()})
                                    }
                                }
                            }

                        }
                    }
                
                .onAppear {
                    getSongs()
                    getImage()
                }
                .environment(\.colorScheme, isDark ? .dark : .light) // modify the color sheme based on the state variable
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        HStack {
                            if pictureName == "" {
                                // if no profile image yet, display default
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(Color("text-color"))
                            } else {
                                // if profile image, display the saved image from firebase storage
                                AsyncImage(url: URL(string: pictureName)){ phase in
                                    if let i = phase.image{
                                        i
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(Circle())
                                            .frame(width: 45, height: 45)
                                    } else if phase.error != nil{
                                        Image(systemName: "person.circle.fill").font(.system(size: 30))
                                    } else {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                            .frame(width: 45, height: 45)
                                    }
                                }
                            }
                            Text("Your Library")
                                .font(.custom("Nunito-Bold", size: 25))
                                .foregroundColor(Color("text-color"))
                        }
                        .padding(.bottom)
                    }
                }
            }
            } else {
                LogInView(isDark: $isDark)
        }
    
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView(isDark: .constant(false)).environmentObject(SongViewModel())
    }
}
