//
//  DashBoardView.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 12/09/2023.
//

import SwiftUI

struct DashBoardView: View {
    var body: some View {
        ScrollView {
            // MARK: BACKGROUND
            Color("bg-color")
                .edgesIgnoringSafeArea(.all)
            
            // MARK: HEADER
            HStack {
                Text("Good Evening")
                    .font(.custom("Nunito-Bold", size: 30))
                Spacer()
                HStack {
                    Image(systemName: "gearshape")
                        .font(.system(size: 25))
                    Image(systemName: "moon")
                        .font(.system(size: 25))
                }
            }
            .padding()
        }
        
        
    }
}

struct DashBoardView_Previews: PreviewProvider {
    static var previews: some View {
        DashBoardView()
    }
}
