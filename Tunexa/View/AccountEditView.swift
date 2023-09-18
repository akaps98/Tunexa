//
//  AccountEditView.swift
//  Tunexa
//
//  Created by Tony on 2023/09/13.
//

import SwiftUI
import PhotosUI
import FirebaseStorage

struct AccountEditView: View {
    // MARK: - VARIABLES
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
            ScrollView {
                VStack {
                    Group {
                        // MARK: - EDIT PROFILE PIC
                        VStack {
                            if let image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .frame(width:300)
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
                                                .frame(width:300)
                                            } else if phase.error != nil{
                                                Image(systemName: "person.circle.fill").font(.system(size: 200))
                                            } else {
                                                ProgressView()
                                                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                                    .frame(width: 200, height: 200)
                                            }
                                        }
                                    }
                                }
                            }
                            PhotosPicker("Select image...", selection: $imageItem, matching: .images)
                        }.padding(.top,100)
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
                    Image(systemName: "info.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                    // MARK: - NEW PASSWORD TEXTFIELD
                    Text("Username")
                        .font(.custom("Nunito-Bold", size: 26))
                        .offset(x: -85)
                    TextField("\(Image(systemName: "person"))  Username", text: $newUsername)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.07))
                        .cornerRadius(10)
                        .font(.custom("Nunito-Bold", size: 22))
                    Text("Introduction")
                        .font(.custom("Nunito-Bold", size: 26))
                        .offset(x: -70)
                        // MARK: - NEW INTRODUCTION TEXTFIELD
                    TextField("\(Image(systemName: "pencil.line")) Introduction", text: $newDesc, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                        .multilineTextAlignment(.leading)
                        .padding()
                        .frame(width: 300, height: 150)
                        .background(Color.black.opacity(0.07))
                        .cornerRadius(10)
                        .font(.custom("Nunito-Bold", size: 22))
                        HStack(spacing: -20) {
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
                                        .foregroundColor(.white)
                                        .font(.custom("Nunito-Bold", size: 22))
                                        .frame(width: 100, height: 20)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                        )
                                        .padding()
                                }
                            }.offset(y: 10)
                            if !isUploading {
                                Button {
                                    // MARK: - CANCEL BUTTON
                                    presentationMode.wrappedValue.dismiss()
                                    isEditViewPresented = false // Dismiss the EditView
                                    onDismiss() // Call the onDismiss closure
                                } label: {
                                    Text("Cancel")
                                        .foregroundColor(.white)
                                        .font(.custom("Nunito-Bold", size: 22))
                                        .frame(width: 100, height: 20)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                        )
                                        .padding()
                                }.offset(y: 10)
                            }
                        }
                    }.offset(y: -90)
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
