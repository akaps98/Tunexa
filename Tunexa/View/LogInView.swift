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
  Acknowledgement: None
*/

import SwiftUI
import FirebaseAuth
import LocalAuthentication

struct LogInView: View {
    // MARK: ***** PROPERTIES *****
    @AppStorage("uid") var isLoggedIn: Bool = Auth.auth().currentUser != nil
    @AppStorage("isAdmin") var isAdmin: Bool = false
    
    @AppStorage("useFaceId") var useFaceId = false
    @AppStorage("faceIdEmail") var faceIdEmail = ""
    @AppStorage("faceIdPassword") var faceIdPassword = ""
    
    /**
     Function: for faceID usage checking
     */
    func getBioMetricStatus()->Bool{
        let scanner = LAContext()
        // this function checks if the iphone user enrolled the faceID
        return scanner.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: .none)
    }

    // MARK: - VARIABLES
    @Binding var isDark: Bool
    
    @State private var showingAlert = false
    @State var message = ""
    
    @State var email = ""
    @State var password = ""
    
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
                    
                    // MARK: - SIGN IN TEXT
                    Text("Sign in")
                        .font(.custom("Nunito-ExtraBold", size: 40))
                    
                    // MARK: TEXTFIELD
                    VStack(spacing: 10) {
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
                        
                        // MARK: - FACE ID
                        // show only if the Iphone's faceID usage is possible
                        if getBioMetricStatus() {
                            // if FaceID is already set to an account
                            if useFaceId && faceIdEmail != "" {
                                Button {
                                    print("do FaceID")
                                    
                                    Task {
                                        do {
                                            let status = try await LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To login to the application")
                                            if status {
                                                do {
                                                    _ = try await Auth.auth().signIn(withEmail: faceIdEmail, password: faceIdPassword)
                                                    isLoggedIn = true
                                                    message = "Welcome to Tunexa!"
                                                    if (faceIdEmail == "Admin@email.com") {
                                                        isAdmin = true
                                                    } else {
                                                        isAdmin = false
                                                    }
                                                } catch {
                                                    // Firebase authentication error
                                                    message = error.localizedDescription
                                                }
                                            } else {
                                                // Face ID authentication failed
                                                message = "Face ID authentication failed"
                                            }
                                            showingAlert.toggle()
                                        }
                                    }
                                    
                                } label: {
                                    VStack {
                                        Label {
                                            Text("Use FaceID to login")
                                        } icon: {
                                            Image(systemName: "faceid").font(.system(size: 25))
                                        }
                                        .foregroundColor(Color("dark-gray"))
                                        .font(.custom("Nunito-Bold", size: 20))
                                        
                                        Text("Note: you can turn off in the account view")
                                            .font(.custom("Nunito-Regular", size: 15))
                                            .foregroundColor(Color("dark-gray"))
                                    }
                                }
                                .padding()
                                .alert(isPresented: $showingAlert) {
                                    Alert(title: Text((message=="Welcome to Tunexa!") ? "Success" : "Error"),
                                          message: Text(message),
                                          dismissButton: .default(Text((message=="Welcome to Tunexa!") ? "Okay" : "Retry")) { showingAlert.toggle() }
                                    )
                                }
                            } else if useFaceId && faceIdEmail == "" { // if the face ID is not set to an account yet
                                Toggle(isOn: $useFaceId) {
                                    Text("Use Face ID to login")
                                        .foregroundColor(Color("light-gray"))
                                        .font(.custom("Nunito-Bold", size: 20))
                                }.frame(width:290).padding(7)
                                VStack {
                                    Label {
                                        Text("Login first to use the FaceID")
                                    } icon: {
                                        Image(systemName: "faceid").font(.system(size: 25))
                                    }
                                    .foregroundColor(Color("dark-gray"))
                                    .font(.custom("Nunito-Bold", size: 20))
                                }.frame(width:300).padding()
                            } else {
                                Toggle(isOn: $useFaceId) {
                                    Text("Use Face ID to login")
                                        .foregroundColor(Color("light-gray"))
                                        .font(.custom("Nunito-Bold", size: 20))
                                }.frame(width:290).padding(7)
                            }
                        }
                        
                        // MARK: - LOG IN BUTTON
                        Button {
                            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                                if let error = error as NSError? {
                                    message = error.localizedDescription
                                    showingAlert.toggle()
                                    return
                                }
                                if authResult != nil {
                                    if useFaceId  && faceIdEmail == "" { // When user is using faceID, set the faceID account information
                                        print("faceID info set")
                                        faceIdEmail = email
                                        faceIdPassword = password
                                    }
                                    isLoggedIn = true
                                    message = "Welcome to Tunexa!"
                                    if (email == "Admin@email.com") { // When user is admin, update isAdmin AppStorage variable
                                        isAdmin = true
                                    } else {
                                        isAdmin = false
                                    }
                                }
                                showingAlert.toggle()
                            }
                        } label: {
                            Text("Log in")
                                .frame(width: 270, height: 30)
                                .modifier(ButtonModifier())
                                .alert(isPresented: $showingAlert) {
                                    Alert(title: Text((message=="Welcome to Tunexa!") ? "Success" : "Error"),
                                          message: Text(message),
                                          dismissButton: .default(Text((message=="Welcome to Tunexa!") ? "Okay" : "Retry")) {
                                        showingAlert.toggle()
                                    }
                                    )
                                }
                                .padding(.top)
                        }
                        
                        // MARK: - LINK TO SIGNUP VIEW
                        NavigationLink(destination: SignUpView(isDark: $isDark)) {
                            Text("Don't have account?")
                            
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .environment(\.colorScheme, isDark ? .dark : .light) // modify the color sheme based on the state variable
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView(isDark: .constant(false))
    }
}
