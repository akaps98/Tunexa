/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Team: Squad 21 (Group 21)
  Members:
  1. Nguyen Anh Duy (s3878141) - Main Contributor
  2. Seoungjoon Hong (s3726123) - Main Contributor
  3. Junsik Kang (s3916884)
  4. Christina Yoo (s3938331) - Main Contributor
  5. Nguyen Hoang Viet (s3926104)
  Created date: 13/09/2023
  Last modified: 22/09/2023
  Acknowledgement: None
*/


import SwiftUI
import PhotosUI

struct AdminDashboardView: View {
    // MARK: ***** PROPERTIES *****
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
    @State private var showingAlert = false
    @State private var message = ""
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
                    
                    // MARK: CREATE NEW SONG SECTION
                    VStack {
                        Text("Create a new song")
                            .font(.custom("Nunito-ExtraBold", size: 24))
                        
                        // MARK: TEXTFIELD AREAS
                        TextField("Name of the song", text: $name)
                            .modifier(TextFieldModifier())
                            .frame(width: 350, height: 50)
                            .padding(.bottom)
                        
                        TextField("Name of the artist", text: $artist)
                            .modifier(TextFieldModifier())
                            .frame(width: 350, height: 50)
                            .padding(.bottom)
                        
                        // MARK: CATEGORIES PICKERS
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
                        
                        // MARK: ADD SONG BUTTON
                        Button{
                            if albumImage != nil && artistImage != nil { // check for empty artist image and song image
                                songCategories = []
                                if firstCategory != "" && name != "" && artist != ""{ // check if all the input fields have data
                                    songCategories.append(firstCategory)
                                    if secondCategory != ""{
                                        songCategories.append(secondCategory)
                                    }
                                    // Create and add the new song info to the database
                                    let avatar = albumImage!.pngData()!
                                    let artistPic = artistImage!.pngData()!
                                    songViewModel.addNewSongData(author: artist, name: name, avatar: avatar, categories: songCategories, artistPic: artistPic)
                                    message = "Add song successfully!"
                                } else {
                                    message = "Please select at least 1 category for this song!"
                                }
                            } else {
                                message = "Please include both the song image and the artist image!"
                            }
                            showingAlert.toggle()
                        } label: {
                           Text("Add Song")
                                .frame(width: 150, height: 20)
                                .modifier(ButtonModifier())
                                // Display alert message
                                .alert(isPresented: $showingAlert) {
                                    Alert(title: Text((message=="Add song successfully!") ? "Success" : "Error"),
                                          message: Text(message),
                                          dismissButton: .default(Text((message=="Add song successfully!") ? "Continue" : "Retry")) {
                                        showingAlert.toggle()
                                    }
                                    )
                                }
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
                // MARK: BACK BUTTON
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
                
                // MARK: HEADER TEXT
                ToolbarItem(placement: .principal) {
                    Text("Admin Dashboard")
                        .modifier(NavigationHeaderModifier())
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}
