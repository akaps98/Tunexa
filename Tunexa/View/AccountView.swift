//
//  AccountView.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 13/09/2023.
//

import SwiftUI
import PhotosUI
import FirebaseAuth

struct AccountView: View {
    // MARK: - VARIABLES
    @AppStorage("uid") var isLoggedIn: Bool = Auth.auth().currentUser != nil
    
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
            NavigationView {
                ZStack {
                    // MARK: - BACKGROUND COLOR
                    Color("bg-color")
                        .edgesIgnoringSafeArea(.all)
                    ScrollView {
                        VStack {
                            if let user = user {
                                // MARK: - PROFILE PIC
                                if user.pictureName == "" {
                                    Image(systemName: "person.circle.fill").font(.system(size: 200)).padding().padding(.bottom,100)
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
                                    }.padding().padding(.bottom,100)
                                }
                            
                                if(user.name == "") {
                                    // MARK: - USERNAME
                                    Text("\(user.email)")
                                        .font(.custom("Nunito-Bold", size: 22))
                                        .offset(y:-110)
                                } else {
                                    // MARK: - EMAIL
                                    Text("\(user.name)")
                                        .font(.custom("Nunito-Bold", size: 22))
                                        .offset(y:-110)
                                }
                                // MARK: - LINK TO ACCOUNTEDIT VIEW
                                NavigationLink(destination: AccountEditView(isDark: $isDark, isEditViewPresented: $isEditViewPresented, onDismiss: {
                                    // This closure will be called when the AccountEditView is dismissed
                                    // You can trigger any actions here, such as refreshing data
                                    getData()
                                })) { Text("Edit profile...")}.offset(y: -95)
                                Group {
                                    Image(systemName: "info.circle")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                    // MARK: - INTRODUCTION
                                    
                                    GroupBox(label:
                                                Label("\(Image(systemName: "pencil.line"))  Introduction", systemImage: "")
                                        .font(.custom("Nunito-SemiBold", size: 26))
                                    ) {
                                        ScrollView(.vertical, showsIndicators: true) {
                                            Text(user.description)
                                                .font(.custom("Nunito-Light", size: 28))
                                                .multilineTextAlignment(.center)
                                        }
                                        .frame(height: 140)
                                    }
                                    // MARK: - LOGOUT BUTTON
                                    Button {
                                        let firebaseAuth = Auth.auth()
                                        do {
                                            try firebaseAuth.signOut()
                                            isLoggedIn = false
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
                                            .padding()
                                    }.offset(y: 10)
                                }.offset(y: -80)
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
