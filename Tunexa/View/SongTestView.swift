//
//  SongTestView.swift
//  Tunexa
//
//  Created by SeongJoon, Hong  on 13/09/2023.
//


import SwiftUI
import PhotosUI

struct SongTestView: View {
    @StateObject private var songViewModel = SongViewModel()
    @State private var name = ""
    @State private var artist = ""
    @State private var albumImage: UIImage?
    @State private var image: Image?
    @State private var imageItem: PhotosPickerItem?
    @State private var artistImage: UIImage?
    @State private var artistImageViewer: Image?
    @State private var artistImageItem: PhotosPickerItem?
    @State private var firstCategory = ""
    @State private var secondCategory = ""
    @State private var isOpenDocumentPicker = false
    @State private var songCategories: [String] = []
    var body: some View {
        VStack{
            // MARK: CREATE NEW SONG
            TextField("Name of the song", text: $name)
            TextField("Name of the artist", text: $artist)
            HStack{
                Picker(selection: $firstCategory, label: Text("Select a Category")) {
                    if(firstCategory == ""){
                        Text("Select Category").tag("Placeholder")
                    }
                    ForEach(categories, id: \.self) { category in
                        Text(category.name).tag(category.name)
                    }
                }
                if firstCategory != ""{
                    Picker(selection: $secondCategory, label: Text("Select a Category")) {
                        if(secondCategory == ""){
                            Text("Select Category").tag("Placeholder")
                        }
                        ForEach(categories, id: \.self) { category in
                            if category.name != firstCategory{
                                Text(category.name).tag(category.name)
                            }
                        }
                    }
                }
            }
            // MARK: ALBUM IMAGE PICKER
            HStack{
                PhotosPicker("Select Album Image", selection: $imageItem, matching: .images)
                if let image{
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                }
            }
            .onChange(of: imageItem){ _ in
                Task{
                    if let data = try? await imageItem?.loadTransferable(type: Data.self){
                        if let uiImage = UIImage(data: data){
                            albumImage = uiImage
                            image = Image(uiImage: albumImage!)
                            return
                        }
                    }
                }
            }
            // MARK: ARTIST IMAGE PICKER
            HStack{
                PhotosPicker("Select Artist Image", selection: $artistImageItem, matching: .images)
                if let artistImageViewer{
                    artistImageViewer
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                }
            }
            .onChange(of: artistImageItem){ _ in
                Task{
                    if let data = try? await artistImageItem?.loadTransferable(type: Data.self){
                        if let uiImage = UIImage(data: data){
                            artistImage = uiImage
                            artistImageViewer = Image(uiImage: artistImage!)
                            return
                        }
                    }
                }
            }
            Button{
                if albumImage != nil && artistImage != nil{
                    songCategories = []
                    if firstCategory != "" && name != "" && artist != ""{
                        songCategories.append(firstCategory)
                        if secondCategory != ""{
                            songCategories.append(secondCategory)
                        }
                        let avatar = albumImage!.pngData()!
                        let artistPic = artistImage!.pngData()!
                        songViewModel.addNewSongData(author: artist, name: name, avatar: avatar, categories: songCategories, artistPic: artistPic)
                    }
                }
            } label: {
               Text("add")
            }
            // MARK: GET SONGS
            NavigationView{
                List{
                    ForEach(songViewModel.songs, id: \.id){ song in
                        NavigationLink(destination: SongUpdateTestView(song: song)){
                            HStack{
                                Text(song.name ?? "")
                                Text(song.author[0] ?? "")
                                AsyncImage(url: URL(string: song.author[1] ?? "")){ phase in
                                    if let i = phase.image{
                                        i
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                    }else if phase.error != nil{
                                        Rectangle()
                                            .frame(width: 100, height: 100)
                                    }else{
                                        Rectangle()
                                            .frame(width: 100, height: 100)
                                    }
                                }
                                // MARK: SONG AVATAR DISPLAY
                                AsyncImage(url: URL(string: song.avatarName ?? "")){ phase in
                                    if let i = phase.image{
                                        i
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                    }else if phase.error != nil{
                                        Rectangle()
                                            .frame(width: 100, height: 100)
                                    }else{
                                        Rectangle()
                                            .frame(width: 100, height: 100)
                                    }
                                }
                            }
                            .onLongPressGesture{
                                songViewModel.deleteSongData(id: song.id!, name: song.name!, author: song.author[0]!)
                            }
                        }
                    }
                }
                .navigationTitle("Song Titles")
            }
        }
    }
}

struct SongTestView_Previews: PreviewProvider {
    static var previews: some View {
        SongTestView()
    }
}
