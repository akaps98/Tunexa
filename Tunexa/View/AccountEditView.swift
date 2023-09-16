//
//  AccountEditView.swift
//  Tunexa
//
//  Created by Tony on 2023/09/13.
//

import SwiftUI

// MARK: - VALIDATION STATUS
enum PasswordStatus {
    case blankInfo, passwordLength, doublecheck, editSuccess
}

struct AccountEditView: View {
    // MARK: - VARIABLES
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var isDark: Bool
    
    @State private var showingAlert = false
    @State private var status: PasswordStatus = .editSuccess
    
    @State var isLoggedIn = false // check the user is logged in
    
    @State private var showingImagePicker = false
    @State var pickedImage = Image("testPic") // profile pic
    
    @State var newPassword = ""
    @State var checkPassword = ""
    @State var newDesc = ""
    
    // MARK: - FUNCTION; EDITION
    func edit(newPassword: String, checkPassword: String) {
        if(newPassword == "" && checkPassword == "") {
            status = .editSuccess
            return
        }
        if(newPassword.count == 8) {
            if(newPassword == checkPassword) {
                status = .editSuccess
            } else {
                status = .doublecheck
            }
        } else {
            status = .passwordLength
        }
    }
    
    var body: some View {
        ZStack {
            // MARK: - BACKGROUND COLOR
            Color("bg-color")
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack {
                    // MARK: - EDIT MY ACCOUNT TEXT
                    Text("Edit my account")
                        .font(.custom("Nunito-Bold", size: 37))
                    // MARK: - EDIT PROFILE PIC
                    pickedImage
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle().inset(by: 50))
                        .offset(y:-60)
                    // MARK: - ALLOW TO SELECT IMAGE FROM LOCAL DEVICE
                    Button(action: {
                        self.showingImagePicker.toggle()
                    }, label: {
                        Text("Select image...")
                    }).offset(y:-105)
                    Group {
                    Image(systemName: "info.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Text("New Password")
                        .font(.custom("Nunito-Bold", size: 26))
                        .offset(x: -53)
                    // MARK: - NEW PASSWORD TEXTFIELD
                    SecureField("\(Image(systemName: "lock"))  New password", text: $newPassword)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.07))
                        .cornerRadius(10)
                        .font(.custom("Nunito-Bold", size: 22))
                        // MARK: - CONFIRMATION TEXTFIELD
                    SecureField("\(Image(systemName: "checkmark"))  Confirm", text: $checkPassword)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.07))
                        .cornerRadius(10)
                        .font(.custom("Nunito-Bold", size: 22))
                    Text("New Introduction")
                        .font(.custom("Nunito-Bold", size: 26))
                        .offset(x: -38)
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
                                edit(newPassword: newPassword, checkPassword: checkPassword)
                                self.showingAlert.toggle()
                                if(status == .editSuccess) {
                                    if(newDesc == "") { // there is any new introduction
                                        print($newPassword)
                                    } else {
                                        print($newPassword, $newDesc)
                                    }
                                    presentationMode.wrappedValue.dismiss()
                                }
                            } label: {
                                Text("Edit")
                                    .foregroundColor(.white)
                                    .font(.custom("Nunito-Bold", size: 22))
                                    .frame(width: 100, height: 20)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                    )
                                    .padding()
                                    .alert(isPresented: $showingAlert) {
                                        // MARK: - VALIDATION
                                        switch status {
                                        case .blankInfo:
                                            return Alert(title: Text("Wrong"), message: Text("Please fill in the blank!"))
                                        case .passwordLength:
                                            return Alert(title: Text("Wrong"), message: Text("Password must be at least 8 characters long!"))
                                        case .doublecheck:
                                            return Alert(title: Text("Wrong"), message: Text("Double-check the password!"))
                                        case .editSuccess:
                                            return Alert(title: Text("Success"), message: Text("Successfully edited!"))
                                        }
                                    }
                            }.offset(y: 10)
                            Button {
                                // MARK: - CANCEL BUTTON
                                presentationMode.wrappedValue.dismiss()
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
                    }.offset(y: -90)
                    // MARK: - SELECT IMAGE
                }.sheet(isPresented: $showingImagePicker) {
                    PhotoPicker(sourceType: .photoLibrary) { (image) in
                        self.pickedImage = Image(uiImage: image)
                        print(image)
                    }
                }
            }.navigationBarBackButtonHidden(true)
                .environment(\.colorScheme, isDark ? .dark : .light) // modify the color sheme based on the state variable
        }
    }
}

struct AccountEditView_Previews: PreviewProvider {
    static var previews: some View {
        AccountEditView(isDark: .constant(false))
    }
}
