/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Team: Squad 21 (Group 21)
  Members:
  1. Nguyen Anh Duy (s3878141) - Sub Contributor
  2. Seoungjoon Hong (s3726123) - Main Contributor
  3. Junsik Kang (s3916884)
  4. Christina Yoo (s3938331) - Main Contributor
  5. Nguyen Hoang Viet (s3926104)
  Created date: 14/09/2023
  Last modified: 22/09/2023
  Acknowledgement:
*/

import SwiftUI
import PhotosUI

struct SongUpdateCard: View {
    // MARK: ***** PROPERTIES *****
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
    
    @State private var showingAlert = false
    @State private var message = ""
    
    var body: some View {
        VStack(alignment: .center) {
            // MARK: TITLE
            Text("Update this song")
                .font(.custom("Nunito-ExtraBold", size: 24))
            
            // MARK: SONG UPDATE FORM
            TextField(song.name ?? "", text: $name)
                .modifier(TextFieldModifier())
                .frame(width: 350, height: 50)
                .padding(.bottom)
                .onAppear{
                    name = song.name ?? ""
                }
                
            TextField(song.author[0] ?? "", text: $artist)
                .modifier(TextFieldModifier())
                .frame(width: 350, height: 50)
                .padding(.bottom)
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
            
            // MARK: UPDATE BUTTON
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
                    message = "Updated information successfully!"
                    showingAlert.toggle()
                } label: {
                   Text("Update")
                        .frame(width: 100, height: 20)
                        .modifier(ButtonModifier())
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Success"), message: Text(message), dismissButton: .default(Text("Continue")) {
                        showingAlert.toggle()
                        presentationMode.wrappedValue.dismiss()
                    })
                }
                
                // MARK: CANCEL BUTTON
                Button{
                    // Remove the current view and return to the previous view
                    presentationMode.wrappedValue.dismiss()
                } label: {
                   Text("Cancel")
                        .frame(width: 100, height: 20)
                        .modifier(ButtonModifier())
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        
    }
}
