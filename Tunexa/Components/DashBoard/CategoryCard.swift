//
//  CategoryCard.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 17/09/2023.
//

import SwiftUI

struct CategoryCard: View {
    @EnvironmentObject var songViewModel: SongViewModel
    let category: Category
    let bgColor: Color
    @State var categoryList: [Song] = []
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode> // Store the presented value when the view is navigated
    
    // MARK: FILTER SONG BASED ON CATEGORY
    func filterSong() {
        categoryList = []
        for song in songViewModel.songs {
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
            VStack {
                ScrollView {
                    VStack {
                        ZStack {
                            LinearGradient(gradient: Gradient(colors: [bgColor, bgColor, bgColor, Color("light-gray")]), startPoint: .top, endPoint: .bottom)
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
                        
                        VStack {
                            ForEach(categoryList, id: \.self) {song in
                                SongRow(song: song)
                            }
                        }
                        .padding(.bottom, 100)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        // Remove the current view and return to the previous view
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left.circle.fill")
                            .foregroundColor(Color("text-color"))
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
        .onAppear {
            filterSong()
        }
    }
}

struct CategoryCard_Previews: PreviewProvider {
    static var previews: some View {
        CategoryCard(category: categories[2], bgColor: .orange)
            .environmentObject(SongViewModel())
    }
}
