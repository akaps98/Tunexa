//
//  LibraryView.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 13/09/2023.
//

import SwiftUI
import FirebaseAuth

struct LibraryView: View {
    @AppStorage("uid") var isLoggedIn: Bool = Auth.auth().currentUser != nil
    
    @Binding var isDark: Bool
    @State var showAddSongSheet = false
    
    @EnvironmentObject var songViewModel: SongViewModel
    
    @State var playlistSongs: [Song] = []
    //fetch user's saved playlist from firebase
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
    
    @State var pictureName = ""
    //fetch user's profile image from firebase
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
            ZStack {
                // MARK: BACKGROUND
                Color("bg-color")
                    .edgesIgnoringSafeArea(.all)
                
                // MARK: CONTENT
                VStack {
                    HStack {
                        HStack {
                            if pictureName == "" {
                                // if no profile image yet, display default
                                Image(systemName: "person.circle.fill").font(.system(size: 35))
                            } else {
                                // if profile image, display the saved image from firebase storage
                                AsyncImage(url: URL(string: pictureName)){ phase in
                                    if let i = phase.image{
                                        i
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(Circle())
                                            .frame(width:65)
                                    } else if phase.error != nil{
                                        Image(systemName: "person.circle.fill").font(.system(size: 50))
                                    } else {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                            .frame(width: 60, height: 60)
                                    }
                                }
                            }
                            Text("Your Library")
                                .font(.custom("Nunito-ExtraBold", size: 30))
                                .foregroundColor(Color("text-color"))
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    ScrollView {
                        VStack {
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: 250, height: 250)
                                .foregroundColor(Color("secondary-color"))
                                .overlay {
                                    Image(systemName: "music.note")
                                        .font(.system(size: 80))
                                        .foregroundColor(Color("text-color"))
                                }
                            
                            Text("Your Playlist")
                                .font(.custom("Nunito-Bold", size: 25))
                        }
                        .padding([.horizontal,.bottom])
                        
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
                                        Image(systemName: "pencil")
                                            .font(.system(size: 25))
                                            .foregroundColor(Color(!editMode ? "text-color" : "AccentColor"))
                                    }
                                    
                                }
                                
                                Spacer()
                                
                                // MARK: SHUFFLE BUTTON
                                
                                HStack(spacing: 10) {
                                    Button {
                                        editMode = false
                                        print("shuffle")
                                    } label: {
                                        Image(systemName: "shuffle")
                                            .font(.system(size: 22))
                                            .foregroundColor(Color("text-color"))
                                    }
                                    
                                    // MARK: PLAY BUTTON
                                    Button {
                                        editMode = false
                                        print("play playlist")
                                    } label: {
                                        ZStack {
                                            Circle()
                                                .frame(width: 50)
                                                .foregroundColor(Color("primary-color"))
                                                .overlay {
                                                    Image(systemName: "triangle.fill")
                                                        .foregroundColor(Color("text-color"))
                                                        .rotationEffect(Angle(degrees: 90))
                                                        .offset(x: 2)
                                                }
                                        }
                                    }
                                }
                                
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
