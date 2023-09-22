//
//  SignUpView.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 12/09/2023.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpView: View {
    // MARK: - VARIABLES
    @Environment(\.presentationMode) var presentationMode
        
    @Binding var isDark: Bool
    
    @State private var showingAlert = false
    @State private var message = ""
        
    @State var email = ""
    @State var password = ""
    @State var checkPassword = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                // MARK: - BACKGROUND COLOR
                Color("bg-color")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    // MARK: - APP LOGO
                    Image("logo-icon-transparent")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: 120)
                        .padding()
                    VStack {
                        // MARK: - REGISTER TEXT
                        Text("Register")
                            .font(.custom("Nunito-ExtraBold", size: 40))
                        // MARK: - EMAIL TEXTFIELD
                        TextField("\(Image(systemName: "envelope.fill")) Email", text: $email)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.black.opacity(0.07))
                            .cornerRadius(10)
                            .font(.custom("Nunito-Regular", size: 22))
                            .textInputAutocapitalization(.never)
                        // MARK: - PASSWORD TEXTFIELD
                        SecureField("\(Image(systemName: "lock.fill"))  Password", text: $password)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.black.opacity(0.07))
                            .cornerRadius(10)
                            .font(.custom("Nunito-Regular", size: 22))
                            .textInputAutocapitalization(.never)
                        // MARK: - CONFIRMATION TEXTFIELD
                        SecureField("\(Image(systemName: "checkmark.circle.fill"))  Confirm", text: $checkPassword)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.black.opacity(0.07))
                            .cornerRadius(10)
                            .font(.custom("Nunito-Regular", size: 22))
                            .textInputAutocapitalization(.never)
                        // MARK: - REGISTER BUTTON
                        Button {
                            if (password == checkPassword) {
                                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                                    if let error = error as NSError? {
                                        message = error.userInfo[NSLocalizedDescriptionKey] as? String ?? "Unknown Error"
                                        showingAlert.toggle()
                                        return
                                    }
                                    if let user = authResult?.user {
                                        let uid = user.uid
                                        
                                        let db = Firestore.firestore()
                                        let userInfoCollection = db.collection("UserInfo")
                                        
                                        let userInfoDocument = userInfoCollection.document(uid)
                                        
                                        let initialUserData: [String: Any] = [
                                            "email": email,
                                            "name": "",
                                            "description": "",
                                            "pictureName": "",
                                            "playlist": [Any](),
                                            "favorite": [Any]()
                                            ]
                                        
                                        userInfoDocument.setData(initialUserData) { error in
                                            if let error = error {
                                                print("Error creating Firestore document: \(error.localizedDescription)")
                                            } else {
                                                print("Firestore document created successfully.")
                                            }
                                        }
                                        
                                        message = "Registered successfully!"
                                        showingAlert.toggle()
                                        email = ""
                                        password = ""
                                        checkPassword = ""
                                    }
                                }
                            } else {
                                message="Passwords do not match with each other."
                                checkPassword=""
                                showingAlert.toggle()
                            }
                        } label: {
                            Text("Register")
                                .foregroundColor(.white)
                                .font(.custom("Nunito-Bold", size: 22))
                                .frame(width: 270)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                )
                                .padding()
                                .alert(isPresented: $showingAlert) {
                                    Alert(title: Text((message=="Registered successfully!") ? "Success" : "Error"),
                                        message: Text(message),
                                        dismissButton: .default(Text((message=="Registered successfully!") ? "Okay" : "Retry")) {
                                            if (message=="Registered successfully!") {
                                                presentationMode.wrappedValue.dismiss()
                                                showingAlert.toggle()
                                            } else {
                                                showingAlert.toggle()
                                            }
                                        }
                                    )
                                }
                                .offset(y: 5)
                        }
                        // MARK: - LINK TO LOGIN VIEW
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("I have an account!")
                        }
                        .offset(y: -10)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
         .environment(\.colorScheme, isDark ? .dark : .light) // modify the color sheme based on the state variable
    }
}


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(isDark: .constant(false))
    }
}
