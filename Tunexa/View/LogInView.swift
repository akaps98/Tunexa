//
//  LogInView.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 12/09/2023.
//

import SwiftUI

enum LogInStatus {
    case blankInfo, wrongEmail, wrongPassword, logInSuccess
}

struct LogInView: View {
    // MARK: - VARIABLES
    @Binding var isDark: Bool
    
    @State private var showingAlert = false
    @State private var status: LogInStatus = .wrongEmail
    
    @State var email = ""
    @State var password = ""
    
    // MARK: - FUNCTION; AUTHENTICATION
    func authentication(email: String, password: String) {
        if(email == "" || password == "") {
            status = .blankInfo
            return
        }
        if(email.lowercased() == "tony@gmail.com") {
            if(password.lowercased() == "tony") {
                status = .logInSuccess
            } else {
                status = .wrongPassword
            }
        } else {
            status = .wrongEmail
        }
    }
    
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
                            print($email, $password)
                            authentication(email: email, password: password)
                            self.showingAlert = true
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
                                    // MARK: - VALIDATION
                                    switch status {
                                    case .blankInfo:
                                        return Alert(title: Text("Wrong"), message: Text("Please fill in the blank!"))
                                    case .wrongEmail:
                                        return Alert(title: Text("Wrong"), message: Text("This email address is not registered!"))
                                    case .wrongPassword:
                                        return Alert(title: Text("Wrong"), message: Text("Password is incorrect!"))
                                    case .logInSuccess:
                                        return Alert(title: Text("Success"), message: Text("Welcome to Tunexa!"))
                                    }
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
