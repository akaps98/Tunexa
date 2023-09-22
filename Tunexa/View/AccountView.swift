//
//  AccountView.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 13/09/2023.
//

import SwiftUI
import PhotosUI
import FirebaseAuth
import LocalAuthentication

struct AccountView: View {
    // MARK: - VARIABLES
    @AppStorage("uid") var isLoggedIn: Bool = Auth.auth().currentUser != nil
    @AppStorage("isAdmin") var isAdmin: Bool = false
    @AppStorage("useFaceId") var useFaceId = false
    @AppStorage("faceIdEmail") var faceIdEmail = ""
    @AppStorage("faceIdPassword") var faceIdPassword = ""
    
    // for iPhone faceID usage check
    func getBioMetricStatus()->Bool{
        let scanner = LAContext()
        return scanner.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: .none)
    }
    
    @Binding var isDark: Bool
    
    @State var showingAlert = false
    
    @State private var user: User?
    
    @State private var isEditViewPresented = false
    
    func getData() {
        User.fetch { result in
            switch result {
            case .success(let fetchedUser):
                self.user = fetchedUser
            case .failure(let error):
                print("Error fetching user data: \(error)")
            }
        }
    }
    
    var body: some View { // MARK: - WHEN THE USER IS LOGGED IN
        if (isLoggedIn) {
            NavigationStack {
                ZStack {
                    // MARK: - BACKGROUND COLOR
                    Color("bg-color")
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        if let user = user {
                            // MARK: - PROFILE PIC
                            if user.pictureName == "" {
                                Image(systemName: "person.circle.fill").font(.system(size: 200))
                                    .padding()
                            } else {
                                AsyncImage(url: URL(string: user.pictureName)){ phase in
                                    if let i = phase.image{
                                        i
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(Circle())
                                        .frame(width:230)
                                    } else if phase.error != nil{
                                        Image(systemName: "person.circle.fill").font(.system(size: 200))
                                    } else {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                            .frame(width: 230, height: 230)
                                    }
                                }
                                .padding()
                            }
                        
                            VStack(spacing: 10) {
                                if (user.name == "") {
                                    // MARK: - USERNAME
                                    Text("\(user.email)")
                                        .font(.custom("Nunito-Bold", size: 22))
                                } else {
                                    // MARK: - EMAIL
                                    Text("\(user.name)")
                                        .font(.custom("Nunito-Bold", size: 28))
                                }
                                // MARK: - LINK TO ACCOUNTEDIT VIEW
                                NavigationLink(destination: AccountEditView(isDark: $isDark, isEditViewPresented: $isEditViewPresented, onDismiss: {
                                    // This closure will be called when the AccountEditView is dismissed
                                    // You can trigger any actions here, such as refreshing data
                                    getData()
                                })) { Text("Edit profile...")}
                            }
                            .offset(y: -20)
                            
                            VStack {
                                GroupBox(label:
                                            Label("\(Image(systemName: "rectangle.and.pencil.and.ellipsis"))  Your Bio", systemImage: "")
                                    .font(.custom("Nunito-SemiBold", size: 25))
                                ) {
                                    ScrollView(.vertical, showsIndicators: true) {
                                        Text(user.description)
                                            .font(.custom("Nunito-Light", size: 22))
                                            .multilineTextAlignment(.leading)
                                    }
                                    //.frame(height: 90)
                                    .frame(height: (useFaceId && faceIdEmail == user.email && getBioMetricStatus()) ? 130 : 165)
                                }
                                // MARK: - FACE ID
                                // show only if the iphone's faceID usage is allowed
                                if getBioMetricStatus() {
                                    // if user using the faceID to logged in is logged in
                                    if useFaceId && faceIdEmail == user.email {
                                        // When toggled to false, reset the faceID account info to empty string
                                        Toggle(isOn: Binding(get: { useFaceId }, set: { newValue in
                                            useFaceId = newValue
                                            if !newValue {
                                                print("reset")
                                                faceIdEmail = ""
                                                faceIdPassword = ""
                                            }
                                        })) {
                                            Text("Use FaceID to login to this account")
                                                .foregroundColor(Color("light-gray"))
                                                .font(.custom("Nunito-Bold", size: 17))
                                        }
                                        .frame(width: 350)
                                    }
                                }
                                
                                // MARK: - LOGOUT BUTTON
                                Button {
                                    let firebaseAuth = Auth.auth()
                                    do {
                                        try firebaseAuth.signOut()
                                        isLoggedIn = false
                                        isAdmin = false
                                    } catch let signOutError as NSError {
                                        print("Error signing out: %@", signOutError)
                                    }
                                } label: {
                                    Text("Log out")
                                        .foregroundColor(.white)
                                        .font(.custom("Nunito-Bold", size: 22))
                                        .frame(width: 100, height: 20)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                        )
                                        .padding(10)
                                }
                            }
                        }
                    }
                }
            }
            .environment(\.colorScheme, isDark ? .dark : .light)
            // modify the color sheme based on the state variable
            .onAppear {
                getData()
            }
        } else { // MARK: - WHEN THE USER IS NOT LOGGED IN
            LogInView(isDark: $isDark)
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(isDark: .constant(false))
    }
}
