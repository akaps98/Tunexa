//
//  AccountEditView.swift
//  Tunexa
//
//  Created by Tony on 2023/09/13.
//

import SwiftUI

struct AccountEditView: View {
    @State var isLoggedIn = false // check the user is logged in
    
    @State var email = "tony@gmail.com"
    @State var username = "tony"
    
    var body: some View {
        ZStack {
            Color("bg-color")
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Edit")
            }
        }
    }
}

struct AccountEditView_Previews: PreviewProvider {
    static var previews: some View {
        AccountEditView()
    }
}

