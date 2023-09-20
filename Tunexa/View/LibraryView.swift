//
//  LibraryView.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 13/09/2023.
//

import SwiftUI
import FirebaseAuth

struct LibraryView: View {
    @Binding var isDark: Bool
    @State var isPlaylistEmpty = true
    @State var showAddSongSheet = false
    @State var playlist: [Song] = []
    
    
    @AppStorage("uid") var isLoggedIn: Bool = Auth.auth().currentUser != nil
    
    @State var pictureName = ""
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
                                Image(systemName: "person.circle.fill").font(.system(size: 50))
                            } else {
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
                        
                        HStack {
                            Image(systemName: "gearshape")
                                .font(.system(size: 25))
                                .foregroundColor(Color("text-color"))
                        }
                        
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
                        
                        if !isPlaylistEmpty {
                            HStack {
                                HStack(spacing: 10) {
                                    Button {
                                        print("add")
                                    } label: {
                                        Image(systemName: "plus.circle")
                                            .font(.system(size: 25))
                                            .foregroundColor(Color("text-color"))
                                    }
                                    
                                    Button {
                                        print("edit")
                                    } label: {
                                        Image(systemName: "pencil")
                                            .font(.system(size: 25))
                                            .foregroundColor(Color("text-color"))
                                    }
                                    
                                }
                                
                                Spacer()
                                
                                // MARK: SHUFFLE BUTTON
                                
                                HStack(spacing: 10) {
                                    Button {
                                        print("shuffle")
                                    } label: {
                                        Image(systemName: "shuffle")
                                            .font(.system(size: 22))
                                            .foregroundColor(Color("text-color"))
                                    }
                                    
                                    // MARK: PLAY BUTTON
                                    Button {
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
                        
                        
                        if isPlaylistEmpty {
                            Text("There is nothing in your playlist yet! Ready to customize your own songs?")
                                .font(.custom("Nunito-Regular", size: 18))
                            Button {
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
                            .sheet(isPresented: $showAddSongSheet) {
                                AddSongView(isDark: $isDark)
                                    .presentationDetents([.large])
                                    .presentationDragIndicator(.visible)
                            }
                        } else {
                            ForEach(playlist, id: \.self) { song in
                                SongRow(song: song)
                            }
                        }
                        
                    }
                }
            }
            .onAppear {
                getImage()
                if playlist.isEmpty {
                    isPlaylistEmpty = true
                } else {
                    isPlaylistEmpty = false
                }
            }
            .environment(\.colorScheme, isDark ? .dark : .light) // modify the color sheme based on the state variable
        } else {
            LogInView(isDark: $isDark)
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView(isDark: .constant(false))
    }
}
