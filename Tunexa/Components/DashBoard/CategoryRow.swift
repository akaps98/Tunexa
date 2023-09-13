//
//  CategoryRow.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 13/09/2023.
//
/*
 
 Acknowledgement:
 - clipshape view to hide overflow image: https://stackoverflow.com/questions/65308828/how-to-hide-clipped-views-in-swiftui-hstack
 */

import SwiftUI

struct CategoryRow: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.orange)
                .frame(height: 100)
            
            HStack {
                Spacer()
                Image("song-avatar-1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, alignment: .leading)
                    .rotationEffect(Angle(degrees: 10))
                    .offset(x: 22, y: 10)
            }
            .padding(.trailing)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Podcast")
                        .font(.custom("Nunito-Bold", size: 20))
                    Spacer()
                    
                }
                .padding(.horizontal)
                .offset(y: -22)
            }
        }
        .clipped()
        
    }
}

struct CategoryRow_Previews: PreviewProvider {
    static var previews: some View {
        CategoryRow()
    }
}
