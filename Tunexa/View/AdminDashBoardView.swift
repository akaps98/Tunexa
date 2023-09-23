//
//  SongTestView.swift
//  Tunexa
//
//  Created by SeongJoon, Hong  on 13/09/2023.
//


import SwiftUI
import PhotosUI

struct AdminDashboardView: View {
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
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode> // Store the presented value when the view is navigated
    @EnvironmentObject var songViewModel: SongViewModel
    
    // for updating home view
    var onEdit: (() -> Void)?
    
    @State var isShowingAlert = false
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: BACKGROUND
                Color("bg-color")
                    .edgesIgnoringSafeArea(.all)
                
                // MARK: CONTENT
                ScrollView {
                    
                    // MARK: CREATE NEW SONG
                    VStack {
                        Text("Create a new song")
                            .font(.custom("Nunito-ExtraBold", size: 24))
                        
                        TextField("Name of the song", text: $name)
                            .padding()
                            .frame(width: 350, height: 50)
                            .background(Color.black.opacity(0.07))
                            .cornerRadius(10)
                            .font(.custom("Nunito-Regular", size: 20))
                            .textInputAutocapitalization(.never)
                        TextField("Name of the artist", text: $artist)
                            .padding()
                            .frame(width: 350, height: 50)
                            .background(Color.black.opacity(0.07))
                            .cornerRadius(10)
                            .font(.custom("Nunito-Regular", size: 20))
                            .textInputAutocapitalization(.never)
                        
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
                        
                        HStack {
                            // MARK: ALBUM IMAGE PICKER
                            VStack{
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
                            .padding(.trailing, 15)
                            
                            // MARK: ARTIST IMAGE PICKER
                            VStack{
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
                        }
                        .padding(.horizontal)
                        
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
                           Text("Add Song")
                                .foregroundColor(.white)
                                .font(.custom("Nunito-Bold", size: 22))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                )
                        }
                    } // VStack
                    .padding()
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay (
                        RoundedRectangle(cornerRadius: 8).stroke(Color("secondary-color"), lineWidth: 3)
                    )
                    
                    
                    // MARK: GET SONGS
                        VStack {
                            ForEach(songViewModel.songs, id: \.id){ song in
                                ZStack {
                                    NavigationLink(destination: SongUpdateCard(song: song)) {
                                        SongUpdateRow(song: song)
                                    }
                                }
                                
                        }
                        .padding(.top, 20)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        // Remove the current view and return to the previous view
                        onEdit?()
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left.circle.fill")
                            .foregroundColor(Color("text-color"))
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Admin Dashboard")
                        .font(.custom("Nunito-ExtraBold", size: 20))
                        .foregroundColor(Color("text-color"))
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}
