//
//  LogInView.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 12/09/2023.
//

import SwiftUI
import FirebaseAuth

struct LogInView: View {
    @AppStorage("uid") var isLoggedIn: Bool = Auth.auth().currentUser != nil
    
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
                        // MARK: - LINK TO SIGNUP VIEW
                        NavigationLink(destination: SignUpView(isDark: $isDark)) { Text("Don't have account?") }
                        // MARK: - LOG IN BUTTON
                        Button {
                            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                                if let error = error as NSError? {
                                    message = error.localizedDescription
                                    showingAlert.toggle()
                                    return
                                }
                                if let authResult = authResult {
                                    isLoggedIn = true
                                    message = "Welcome to Tunexa!"
                                    showingAlert.toggle()
                                }
                            }
                        } label: {
                            Text("Log in")
                                .foregroundColor(.white)
                                .font(.custom("Nunito-Bold", size: 22))
                                .frame(width: 270)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                )
                                .padding()
                                .alert(isPresented: $showingAlert) {
                                    Alert(title: Text((message=="Welcome to Tunexa!") ? "Success" : "Error"),
                                        message: Text(message),
                                        dismissButton: .default(Text((message=="Welcome to Tunexa!") ? "Okay" : "Retry")) {
                                            showingAlert.toggle()
                                        }
                                    )
                                }
                        }.offset(y: 10)
                    }.offset(y: -60)
                }
            }.navigationBarBackButtonHidden(true)
             .environment(\.colorScheme, isDark ? .dark : .light) // modify the color sheme based on the state variable
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView(isDark: .constant(false))
    }
}
