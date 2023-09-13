//
//  LogInView.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 12/09/2023.
//

import SwiftUI

enum LogInStatus {
    case wrongEmail, wrongPassword, logInSuccess
}

struct LogInView: View {
    @State private var showingAlert = false
    @State private var status: LogInStatus = .wrongEmail
    
    @State var email = ""
    @State var password = ""
    
    func authentication(email: String, password: String) {
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
                Color("bg-color")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Image("logo-icon-transparent")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: 120)
                        .padding()
                        .offset(y:-80)
                    Group {
                        Text("Sign in")
                            .font(.custom("Nunito-Bold", size: 37))
                        TextField("username", text: $email)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.black.opacity(0.07))
                            .cornerRadius(10)
                            .font(.custom("Nunito-Bold", size: 20))
                        SecureField("password", text: $password)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.black.opacity(0.07))
                            .cornerRadius(10)
                            .font(.custom("Nunito-Bold", size: 20))
                        NavigationLink(destination: SignUpView()) { Text("Don't have account?") }
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
                                    switch status {
                                    case .wrongEmail:
                                        return               Alert(title: Text("Wrong"), message: Text("This email address is not registered!"))
                                    case .wrongPassword:
                                        return               Alert(title: Text("Wrong"), message: Text("Password is incorrect!"))
                                    case .logInSuccess:
                                        return               Alert(title: Text("Success"), message: Text("Welcome to Tunexa!"))
                                    }
                                }
                        }.offset(y: 10)
                    }.offset(y: -60)
                }
            }.navigationBarBackButtonHidden(true)
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
