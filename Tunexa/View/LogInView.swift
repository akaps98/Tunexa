//
//  LogInView.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 12/09/2023.
//

import SwiftUI
import FirebaseAuth
import LocalAuthentication

struct LogInView: View {
    @AppStorage("uid") var isLoggedIn: Bool = Auth.auth().currentUser != nil
    
    @AppStorage("useFaceId") var useFaceId = false
    @AppStorage("faceIdEmail") var faceIdEmail = ""
    @AppStorage("faceIdPassword") var faceIdPassword = ""
    
    // for Iphone faceID usage check
    func getBioMetricStatus()->Bool{
        let scanner = LAContext()
        print(scanner.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: .none))
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
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: 120)
                        .padding()
                        .offset(y:-80)
                    Group {
                        // MARK: - SIGN IN TEXT
                        Text("Sign in")
                            .font(.custom("Nunito-Bold", size: 37))
                        // MARK: - EMAIL TEXTFIELD
                        TextField("\(Image(systemName: "envelope")) Email", text: $email)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.black.opacity(0.07))
                            .cornerRadius(10)
                            .font(.custom("Nunito-Bold", size: 22))
                        // MARK: - PASSWORD TEXTFIELD
                        SecureField("\(Image(systemName: "lock"))  Password", text: $password)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.black.opacity(0.07))
                            .cornerRadius(10)
                            .font(.custom("Nunito-Bold", size: 22))
                        // MARK: - FACE ID
                        // show only if the Iphone's faceID usage is possible
                        if getBioMetricStatus() {
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
                                            Text("Use FaceID to login into the set account")
                                        } icon: {
                                            Image(systemName: "faceid").font(.system(size: 25))
                                        }
                                        .foregroundColor(Color("dark-gray"))
                                        .font(.custom("Nunito", size: 20))
                                        
                                        Text("Note: you can turn off in the account view")
                                            .font(.custom("Nunito", size: 15))
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
                            } else if useFaceId && faceIdEmail == "" {
                                Toggle(isOn: $useFaceId) {
                                    Text("Use Face ID to login")
                                        .foregroundColor(Color("light-gray"))
                                        .font(.custom("Nunito-Bold", size: 20))
                                }.frame(width:290).padding(7)
                                VStack {
                                    Label {
                                        Text("Login first to use the FaceID next time")
                                    } icon: {
                                        Image(systemName: "faceid").font(.system(size: 25))
                                    }
                                    .foregroundColor(Color("dark-gray"))
                                    .font(.custom("Nunito", size: 20))
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
                                        if useFaceId  && faceIdEmail == "" {
                                            print("faceID info set")
                                            faceIdEmail = email
                                            faceIdPassword = password
                                        }
                                        isLoggedIn = true
                                        message = "Welcome to Tunexa!"
                                        showingAlert.toggle()
                                    }
                                }
                            } label: {
                                Text("Log in")
                                    .foregroundColor(.white)
                                    .font(.custom("Nunito-Bold", size: 22))
                                    .frame(width: 270, height: 30)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                    )
                                    .alert(isPresented: $showingAlert) {
                                        Alert(title: Text((message=="Welcome to Tunexa!") ? "Success" : "Error"),
                                              message: Text(message),
                                              dismissButton: .default(Text((message=="Welcome to Tunexa!") ? "Okay" : "Retry")) {
                                            showingAlert.toggle()
                                        }
                                        )
                                    }
                            }.padding(.top,10).offset(y: 10)
                        
                        // MARK: - LINK TO SIGNUP VIEW
                        NavigationLink(destination: SignUpView(isDark: $isDark)) { Text("Don't have account?") }.padding()
                    }.offset(y: -60)
                }
            }
            .offset(y:60)
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
