// https://wwdcbysundell.com/2021/using-swiftui-async-image/
//
//  SongUpdateTestView.swift
//  Tunexa
//
//  Created by SeongJoon, Hong  on 14/09/2023.
//

import SwiftUI
import PhotosUI

struct SongUpdateTestView: View {
    @StateObject private var songViewModel = SongViewModel()
    let song: Song
    @State private var name = ""
    @State private var artist = ""
    @State private var albumImage: UIImage?
    @State private var image: Image?
    @State private var imageItem: PhotosPickerItem?
    @State private var firstCategory = ""
    @State private var secondCategory = ""
    @State private var thirdCategory = ""
    let categories = ["Kpop", "Pop", "Jazz", "Hiphop", "Rock", "R&B", "Dance", "Soul", "Indie", "Punk", "Blues", "Reggae", "EDM", "Country", "Classical", "Latin"]
    @State private var songCategories: [String] = []
    var body: some View {
        
        TextField(song.name ?? "", text: $name)
            .onAppear{
                name = song.name ?? ""
            }
        TextField(song.author ?? "", text: $artist)
            .onAppear{
                artist = song.author ?? ""
            }
        HStack{
            Picker(selection: $firstCategory, label: Text("Select a Category")) {
                if(firstCategory == ""){
                    Text("Select Category").tag("Placeholder")
                }
                ForEach(categories, id: \.self) {
                    Text($0).tag($0)
                }
                .onAppear{
                    firstCategory = song.categories[0]
                }
            }
            if firstCategory != ""{
                Picker(selection: $secondCategory, label: Text("Select a Category")) {
                    if(secondCategory == ""){
                        Text("Select Category").tag("Placeholder")
                    }
                    ForEach(categories, id: \.self) { category in
                        if category != firstCategory{
                            Text(category).tag(category)
                        }
                    }
                }
                .onAppear{
                    if song.categories.count > 1{
                        secondCategory = song.categories[1]
                    }
                }
            }
            if secondCategory != ""{
                Picker(selection: $thirdCategory, label: Text("Select a Category")) {
                    if(thirdCategory == ""){
                        Text("Select Category").tag("Placeholder")
                    }
                    ForEach(categories, id: \.self) { category in
                        if category != firstCategory && category != secondCategory{
                            Text(category).tag(category)
                        }
                    }
                }
                .onAppear{
                    if song.categories.count > 2{
                        thirdCategory = song.categories[2]
                    }
                }
            }
        }
        HStack{
            PhotosPicker("Select Album Image", selection: $imageItem, matching: .images)
            if let image{
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
            }
        
            if albumImage == nil{
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
        Button{
            if firstCategory != "" && name != "" && artist != ""{
                songCategories.append(firstCategory)
                if secondCategory != ""{
                    songCategories.append(secondCategory)
                    if thirdCategory != ""{
                        songCategories.append(thirdCategory)
                    }
                }
                if albumImage != nil{
                    let avatar = albumImage!.pngData()!
                    songViewModel.updateImage(id: song.id!, name: song.name!, avatar: avatar)
                }
                songViewModel.updateSongData(id: song.id!, author: artist, name: name, songURL: "", categories: songCategories)
            }
        } label: {
           Text("Update")
        }
    }
}

