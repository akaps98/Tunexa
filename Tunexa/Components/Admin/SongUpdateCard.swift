// https://wwdcbysundell.com/2021/using-swiftui-async-image/
//
//  SongUpdateCard.swift
//  Tunexa
//
//  Created by SeongJoon, Hong  on 14/09/2023.
//

import SwiftUI
import PhotosUI

struct SongUpdateCard: View {
    let song: Song
    @State private var name = ""
    @State private var artist = ""
    @State private var albumImage: UIImage?
    @State private var image: Image?
    @State private var imageItem: PhotosPickerItem?
    @State private var firstCategory = ""
    @State private var secondCategory = ""
    @State private var songCategories: [String] = []
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode> // Store the presented value when the view is navigated
    @EnvironmentObject var songViewModel: SongViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            // MARK: TITLE
            Text("Update this song")
                .font(.custom("Nunito-ExtraBold", size: 24))
            
            // MARK: SONG UPDATE FORM
            TextField(song.name ?? "", text: $name)
                .padding()
                .frame(width: 350, height: 50)
                .background(Color.black.opacity(0.07))
                .cornerRadius(10)
                .font(.custom("Nunito-Regular", size: 20))
                .textInputAutocapitalization(.never)
                .onAppear{
                    name = song.name ?? ""
                }
            TextField(song.author[0] ?? "", text: $artist)
                .padding()
                .frame(width: 350, height: 50)
                .background(Color.black.opacity(0.07))
                .cornerRadius(10)
                .font(.custom("Nunito-Regular", size: 20))
                .textInputAutocapitalization(.never)
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
            .padding(.bottom)
            
            // MARK: ALBUM IMAGE SELECTOR
            VStack {
                if let image{
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .cornerRadius(5)
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
                PhotosPicker("Select Album Image", selection: $imageItem, matching: .images)
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
            
            HStack {
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
                        .foregroundColor(.white)
                        .font(.custom("Nunito-Bold", size: 22))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                        )
                }
                
                Button{
                    // Remove the current view and return to the previous view
                    presentationMode.wrappedValue.dismiss()
                } label: {
                   Text("Cancel")
                        .foregroundColor(.white)
                        .font(.custom("Nunito-Bold", size: 22))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                        )
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        
    }
}
