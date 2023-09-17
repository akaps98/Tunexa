//
//  CategoryCard.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 17/09/2023.
//

import SwiftUI

struct CategoryCard: View {
    let category: Category
    @State var categoryList: [Song] = []
    let bgColor: Color
    
    // MARK: FILTER SONG BASED ON CATEGORY
    func filterSong() {
        for song in songs {
            for categoryItem in song.categories {
                if categoryItem.lowercased() == category.name.lowercased() {
                    categoryList.append(song)
                    break
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ZStack {
                        LinearGradient(gradient: Gradient(colors: [bgColor, bgColor, bgColor, Color("dark-gray")]), startPoint: .top, endPoint: .bottom)
                            .frame(height: 250)
                        Text(category.name)
                            .foregroundColor(.white)
                            .font(.custom("Nunito-Black", size: 55))
                    }
                    
                    HStack {
                        Text("Songs")
                            .foregroundColor(Color("text-color"))
                            .font(.custom("Nunito-Bold", size: 25))
                        Spacer()
                        
                    }
                    .padding(.horizontal)
                    
                    ForEach(categoryList, id: \.self) {song in
                        SongRow(song: song)
                    }
                    
                    
                }
                
            }
            .edgesIgnoringSafeArea(.all)
        }
        .onAppear {
            filterSong()
        }
    }
}

struct CategoryCard_Previews: PreviewProvider {
    static var previews: some View {
        CategoryCard(category: categories[5], bgColor: .orange)
    }
}
