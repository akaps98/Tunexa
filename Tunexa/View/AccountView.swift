//
//  AccountView.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 13/09/2023.
//

import SwiftUI

struct AccountView: View {
    @State var isLoggedIn = true // check the user is logged in
    
    @State var email = "tony@gmail.com"
    @State var desc = ""
    
    var body: some View {
        if (isLoggedIn) {
            ZStack {
                Color("bg-color")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Account View")
                        .font(.title)
                        .bold()
                    Text("User view and edit account detail here")
                }
            }
        } else {
            LogInView()
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
