//
//  AccountView.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 13/09/2023.
//

import SwiftUI
import Photos
import PhotosUI

struct AccountView: View {
    // MARK: - VARIABLES
    @State var isLoggedIn = true // check the user is logged in
    
    @Binding var isDark: Bool
    
    @State private var showingImagePicker = false
    @State var pickedImage = Image("testPic") // profile pic
    
    @State var email = "tony@gmail.com"
    @State var desc = "I love rock music."
    
    var body: some View { // MARK: - WHEN THE USER IS LOGGED IN
        if (isLoggedIn) {
            NavigationView {
                ZStack {
                    // MARK: - BACKGROUND COLOR
                    Color("bg-color")
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        // MARK: - MY ACCOUNT TEXT
                        Text("My account")
                            .font(.custom("Nunito-Bold", size: 37))
                        // MARK: - PROFILE PIC
                        pickedImage
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle().inset(by: 50))
                            .offset(y:-70)
                        // MARK: - LINK TO ACCOUNTEDIT VIEW
                        NavigationLink(destination: AccountEditView(isDark: $isDark)) { Text("Edit profile...") }.offset(y:-115)
                        Group {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                            // MARK: - EMAIL
                            Text("User: \(email)")
                                .font(.custom("Nunito-Light", size: 30))
                            // MARK: - INTRODUCTION
                            GroupBox(label:
                                    Label("\(Image(systemName: "pencil.line"))  Introduction", systemImage: "")
                                    .font(.custom("Nunito-SemiBold", size: 26))
                                ) {
                                    ScrollView(.vertical, showsIndicators: true) {
                                        Text(desc)
                                            .font(.custom("Nunito-Light", size: 28))
                                            .multilineTextAlignment(.center)
                                    }
                                    .frame(height: 140)
                                }
                        }.offset(y:-90)
                    }
                }
            }.environment(\.colorScheme, isDark ? .dark : .light) // modify the color sheme based on the state variable
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
