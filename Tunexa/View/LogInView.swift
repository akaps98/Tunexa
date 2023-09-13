//
//  LogInView.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 12/09/2023.
//

import SwiftUI
import FirebaseAuth

struct LogInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Log in View")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "mail")
                    TextField("Email", text: $email)
                    Spacer()
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                )
                
                HStack {
                    Image(systemName: "lock")
                    TextField("Password", text: $password)
                    Spacer()
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                )
                
                Button {
                    print("To Sign up View")
                } label: {
                    Text("Don't have an account?")
                }
                
                Button {
                    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                        if let error = error {
                            print(error)
                            return
                        }
                        if let authResult = authResult {
                            print(authResult.user.uid)
                        }
                    }
                    
                } label: {
                    Text("Log in")
                        .foregroundColor(.white)
                        .font(.title3)
                        .bold()
                                    
                        .frame(maxWidth: .infinity)
                        .padding()
                                    
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                        )
                        .padding(.horizontal)
                }
                
            }.padding()
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
