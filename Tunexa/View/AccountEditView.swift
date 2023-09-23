/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Team: Squad 21 (Group 21)
  Members:
  1. Nguyen Anh Duy (s3878141) - Main Contributor
  2. Seoungjoon Hong (s3726123)
  3. Junsik Kang (s3916884) - Main Contributor
  4. Christina Yoo (s3938331) - Main Contributor
  5. Nguyen Hoang Viet (s3926104)
  Created date: 13/09/2023
  Last modified: 22/09/2023
  Acknowledgement: None
*/

import SwiftUI
import PhotosUI
import FirebaseStorage

struct AccountEditView: View {
    // MARK: ***** PROPERTIES *****
    @Environment(\.presentationMode) var presentationMode
    @Binding var isDark: Bool
    
    @State var isLoggedIn = false // check the user is logged in
    @State private var user: User?
    @State var pickedImage = Image(systemName: "person.circle.fill")
    @State var newUsername = ""
    @State var newDesc = ""
    
    @State private var albumImage: UIImage?
    @State private var image: Image?
    @State private var imageItem: PhotosPickerItem?
    
    @State var isImage = false
    @State var isUploading = false
    
    @Binding var isEditViewPresented: Bool
    var onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            // MARK: - BACKGROUND COLOR
            Color("bg-color")
                .edgesIgnoringSafeArea(.all)
            VStack {
                    Group {
                        // MARK: - EDIT PROFILE PIC
                        VStack {
                            if let image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .frame(width:220)
                            } else {
                                if let user = user {
                                    if user.pictureName == "" {
                                        Image(systemName: "person.circle.fill").font(.system(size: 200))
                                    } else {
                                        AsyncImage(url: URL(string: user.pictureName)){ phase in
                                            if let i = phase.image{
                                                i
                                                .resizable()
                                                .scaledToFit()
                                                .clipShape(Circle())
                                                .frame(width:210)
                                            } else if phase.error != nil{
                                                Image(systemName: "person.circle.fill").font(.system(size: 200))
                                            } else {
                                                ProgressView()
                                                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                                    .frame(width: 210, height: 200)
                                            }
                                        }
                                    }
                                }
                            }
                            PhotosPicker("Select image...", selection: $imageItem, matching: .images)
                        }
                        .onChange(of: imageItem){ _ in
                            Task{
                                if let data = try? await imageItem?.loadTransferable(type: Data.self){
                                    if let uiImage = UIImage(data: data){
                                        albumImage = uiImage
                                        image = Image(uiImage: albumImage!)
                                        isImage = true
                                        return
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .listRowSeparatorLeading) {
                            // MARK: - NEW PASSWORD TEXTFIELD
                            Text("Username")
                                .font(.custom("Nunito-Bold", size: 25))
                            TextField("\(Image(systemName: "person"))  Username", text: $newUsername)
                                .modifier(TextFieldModifier())
                                .frame(width: 300, height: 50)
                                .offset(y: -10)
                            Text("Introduction")
                                .font(.custom("Nunito-Bold", size: 26))
                                // MARK: - NEW INTRODUCTION TEXTFIELD
                            TextField("\(Image(systemName: "rectangle.and.pencil.and.ellipsis")) Your Bio", text: $newDesc, axis: .vertical)
                                .lineLimit(4, reservesSpace: true)
                                .multilineTextAlignment(.leading)
                                .modifier(TextFieldModifier())
                                .frame(width: 300, height: 125)
                                .offset(y: -10)
                        }
                        .padding(.top)
                    
                        HStack(spacing: -1) {
                            Button {
                                // MARK: - EDIT BUTTON
                                isUploading = true
                                if isImage {
                                    if let imageData = albumImage?.pngData() {
                                        User.updateImage(avatar: imageData) { result in
                                            switch result {
                                            case .success(_):
                                                print("Picture uploaded and updated successfully.")
                                                User.updateProfile(newDesc: newDesc, newName: newUsername) { error in
                                                    if let error = error {
                                                        print("Error updating information: \(error.localizedDescription)")
                                                        isUploading = false
                                                    } else {
                                                        print("Information updated successfully.")
                                                        isUploading = false
                                                        presentationMode.wrappedValue.dismiss()
                                                        isEditViewPresented = false // Dismiss the EditView
                                                        onDismiss() // Call the onDismiss closure
                                                    }
                                                }
                                            case .failure(let error):
                                                print("Error updating image: \(error.localizedDescription)")
                                                isUploading = false
                                            }
                                        }
                                        isImage = false
                                    }
                                } else {
                                    User.updateProfile(newDesc: newDesc, newName: newUsername) { error in
                                        if let error = error {
                                            print("Error updating information: \(error.localizedDescription)")
                                            isUploading = false
                                        } else {
                                            print("Information updated successfully.")
                                            isUploading = false
                                            presentationMode.wrappedValue.dismiss()
                                            isEditViewPresented = false // Dismiss the EditView
                                            onDismiss() // Call the onDismiss closure
                                        }
                                    }
                                }
                            } label: {
                                if isUploading {
                                    Text("Uploading...")
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                        .frame(width: 100, height: 20)
                                } else {
                                    Text("Edit")
                                        .frame(width: 100, height: 20)
                                        .modifier(ButtonModifier())
                                        .padding()
                                }
                            }
                            if !isUploading {
                                Button {
                                    // MARK: - CANCEL BUTTON
                                    presentationMode.wrappedValue.dismiss()
                                    isEditViewPresented = false // Dismiss the EditView
                                    onDismiss() // Call the onDismiss closure
                                } label: {
                                    Text("Cancel")
                                        .frame(width: 100, height: 20)
                                        .modifier(ButtonModifier())
                                        .padding()
                                }
                            }
                        }
                    
                }
            }.navigationBarBackButtonHidden(true)
                .environment(\.colorScheme, isDark ? .dark : .light) // modify the color sheme based on the state variable
        }
        .onAppear {
            User.fetch { result in
                switch result {
                case .success(let fetchedUser):
                    self.user = fetchedUser
                    newUsername = fetchedUser.name
                    newDesc = fetchedUser.description
                case .failure(let error):
                    print("Error fetching user data: \(error)")
                }
            }
        }
    }
}

struct AccountEditView_Previews: PreviewProvider {
    static var previews: some View {
        AccountEditView(isDark: .constant(false), isEditViewPresented: .constant(true), onDismiss: {})
    }
} 
