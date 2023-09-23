/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Team: Squad 21 (Group 21)
  Members:
  1. Nguyen Anh Duy (s3878141) - Sub Contributor
  2. Seoungjoon Hong (s3726123)
  3. Junsik Kang (s3916884) - Main Contributor
  4. Christina Yoo (s3938331) - Main Contributor
  5. Nguyen Hoang Viet (s3926104)
  Created date: 12/09/2023
  Last modified: 22/09/2023
  Acknowledgement:
*/

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
                        .modifier(LogoModifier())
                    
                    VStack {
                        // MARK: - REGISTER TEXT
                        Text("Register")
                            .font(.custom("Nunito-ExtraBold", size: 40))
                        // MARK: - EMAIL TEXTFIELD
                        TextField("\(Image(systemName: "envelope.fill")) Email", text: $email)
                            .modifier(TextFieldModifier())
                            .frame(width: 300, height: 50)
                            .padding(.bottom)
                            
                        // MARK: - PASSWORD TEXTFIELD
                        SecureField("\(Image(systemName: "lock.fill"))  Password", text: $password)
                            .modifier(TextFieldModifier())
                            .frame(width: 300, height: 50)
                            .padding(.bottom)
                        
                        // MARK: - CONFIRMATION TEXTFIELD
                        SecureField("\(Image(systemName: "checkmark.circle.fill"))  Confirm", text: $checkPassword)
                            .modifier(TextFieldModifier())
                            .frame(width: 300, height: 50)
                            .padding(.bottom)
                        
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
                                .frame(width: 270, height: 30)
                                .modifier(ButtonModifier())
                                .padding(.top)
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
                        }
                        // MARK: - LINK TO LOGIN VIEW
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("I have an account!")
                        }
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
