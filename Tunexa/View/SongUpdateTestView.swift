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
    @State private var songCategories: [String] = []
    var body: some View {
        // MARK: SONG UPDATE FORM
        TextField(song.name ?? "", text: $name)
            .onAppear{
                name = song.name ?? ""
            }
        TextField(song.author[0] ?? "", text: $artist)
            .onAppear{
                artist = song.author[0] ?? ""
            }
        // MARK: CATEGORY SELECTOR
        HStack{
            Picker(selection: $firstCategory, label: Text("Select a Category")) {
                if(firstCategory == ""){
                    Text("Select Category").tag("Placeholder")
                }
                ForEach(categories, id: \.self) { category in
                    Text(category.name).tag(category.name)
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
                        if category.name != firstCategory{
                            Text(category.name).tag(category.name)
                        }
                    }
                }
                .onAppear{
                    if song.categories.count > 1{
                        secondCategory = song.categories[1]
                    }
                }
            }
        }
        // MARK: ALBUM IMAGE SELECTOR
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
            songCategories = []
            if firstCategory != "" && name != "" && artist != ""{
                songCategories.append(firstCategory)
                if secondCategory != ""{
                    songCategories.append(secondCategory)
                }
                if albumImage != nil{
                    let avatar = albumImage!.pngData()!
                    songViewModel.updateImage(id: song.id!, name: song.name!, avatar: avatar)
                }
                let author = [artist, song.author[1] ?? ""]
                if songCategories.count > 1{
                    let category = Array(songCategories[0..<2])
                    songViewModel.updateSongData(id: song.id!, author: author, name: name, categories: category)
                }else{
                    let category = Array(songCategories[0..<1])
                    songViewModel.updateSongData(id: song.id!, author: author, name: name, categories: category)
                }
            }
        } label: {
           Text("Update")
        }
    }
}

