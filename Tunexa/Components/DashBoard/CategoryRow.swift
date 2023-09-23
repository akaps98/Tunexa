/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Team: Squad 21 (Group 21)
  Members:
  1. Nguyen Anh Duy (s3878141) - Main Contributor
  2. Seoungjoon Hong (s3726123)
  3. Junsik Kang (s3916884)
  4. Christina Yoo (s3938331)
  5. Nguyen Hoang Viet (s3926104)
  [Equal Contribution]
  Created date: 13/09/2023
  Last modified: 13/09/2023
  Acknowledgement:
  - Clipshape view to hide overflow image: https://stackoverflow.com/questions/65308828/how-to-hide-clipped-views-in-swiftui-hstack
*/

import SwiftUI

struct CategoryRow: View {
    // MARK: PROPERTIES
    let category: Category
    let bgColor: Color
    
    var body: some View {
        ZStack {
            // MARK: BACKGROUND
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(bgColor)
                .frame(height: 100)
            
            // MARK: CATEGORY BOTTOM RIGHT ICON
            HStack {
                Spacer()
                category.image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, alignment: .leading)
                    .rotationEffect(Angle(degrees: 15))
                    .offset(x: 22, y: 18)
            }
            .padding(.trailing)
            
            // MARK: CATEGORY NAME
            VStack(alignment: .leading) {
                HStack {
                    Text(category.name)
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
        CategoryRow(category: categories[2], bgColor: .orange)
    }
}
