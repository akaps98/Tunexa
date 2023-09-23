/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Team: Squad 21 (Group 21)
  Members:
  1. Nguyen Anh Duy (s3878141) - Main Contributor
  2. Seoungjoon Hong (s3726123) - Sub Contributor
  3. Junsik Kang (s3916884)
  4. Christina Yoo (s3938331)
  5. Nguyen Hoang Viet (s3926104)
  [Equal Contribution]
  Created date: 17/09/2023
  Last modified: 17/09/2023
  Acknowledgement: None
*/

import SwiftUI

struct CategoryCard: View {
    // MARK: ***** PROPERTIES *****
    @EnvironmentObject var songViewModel: SongViewModel
    let category: Category
    let bgColor: Color
    @State var categoryList: [Song] = []
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode> // Store the presented value when the view is navigated
    
    /**
     Function: filter songs based on categories
     */
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
            ScrollView {
                VStack {
                    // MARK: CATEGORY BANNER
                    ZStack {
                        LinearGradient(gradient: Gradient(colors: [bgColor, bgColor, bgColor, Color("light-gray")]), startPoint: .top, endPoint: .bottom)
                            .frame(height: 250)
                        
                        // MARK: CATEGORY TITLE
                        Text(category.name)
                            .foregroundColor(.white)
                            .font(.custom("Nunito-Black", size: 55))
                    }
                    
                    // MARK: HEADLINE
                    HStack {
                        Text("Songs")
                            .modifier(NavigationHeaderModifier())
                        Spacer()
                        
                    }
                    .padding(.horizontal)
                    
                    // MARK: SONG LIST
                    VStack {
                        ForEach(categoryList, id: \.self) {song in
                            SongRow(song: song)
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
            .edgesIgnoringSafeArea(.all)
            // MARK: CUSTOM BACK BUTTON
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
            // Display the list of songs based on the category name
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
