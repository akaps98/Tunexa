//
//  SignUpView.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 12/09/2023.
//

import SwiftUI

enum RegisterStatus {
    case blankInfo, wrongFormat, duplicatedEmail, passwordLength, doublecheck, registerSuccess
}

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingAlert = false
    @State private var status: RegisterStatus = .blankInfo
    
    @State var email = ""
    @State var password = ""
    @State var checkPassword = ""
    
    func registration(email: String, password: String, checkPassword: String) {
        if(email == "" || password == "" || checkPassword == "") {
            status = .blankInfo
            return
        }
        if(email.contains("@")) {
            if(email.lowercased() != "tony@gmail.com") {
                if(password.count == 8) {
                    if(password == checkPassword) {
                        status = .registerSuccess
                    } else {
                        status = .doublecheck
                    }
                } else {
                    status = .passwordLength
                }
            } else {
                status = .duplicatedEmail
            }
        } else {
            status = .wrongFormat
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
                        TextField("email", text: $email)
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
                        SecureField("Type your password again...", text: $checkPassword)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.black.opacity(0.07))
                            .cornerRadius(10)
                            .font(.custom("Nunito-Bold", size: 20))
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("I have an account!")
                        }
                        Button {
                            print($email, $password, $checkPassword)
                            registration(email: email, password: password, checkPassword: checkPassword)
                            self.showingAlert.toggle()
                            if(status == .registerSuccess) {
                                presentationMode.wrappedValue.dismiss()
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
                                    switch status {
                                    case .blankInfo:
                                        return               Alert(title: Text("Wrong"), message: Text("Please fill in the information!"))
                                    case .wrongFormat:
                                        return               Alert(title: Text("Wrong"), message: Text("Wrong email format!"))
                                    case .duplicatedEmail:
                                        return               Alert(title: Text("Wrong"), message: Text("This email address is already exists!"))
                                    case .passwordLength:
                                        return               Alert(title: Text("Wrong"), message: Text("Password must be at least 8 characters long!"))
                                    case .doublecheck:
                                        return               Alert(title: Text("Wrong"), message: Text("Double-check the password!"))
                                    case .registerSuccess:
                                        return               Alert(title: Text("Success"), message: Text("Successfully registered!"))
                                    }
                                }
                        }.offset(y: 10)
                    }.offset(y: -60)
                }
            }.navigationBarBackButtonHidden(true)
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
