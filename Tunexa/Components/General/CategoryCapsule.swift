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
  Created date: 13/09/2023
  Last modified: 13/09/2023
  Acknowledgement: None
*/

import SwiftUI

struct CategoryCapsule: View {
    // MARK: ***** PROPERTIES *****
    let categoryName: String
    
    var body: some View {
        Text(categoryName).textCase(.uppercase)
            .foregroundColor(.white)
            .font(.custom("Nunito-Medium", size: 12))
            .padding(.horizontal, 10)
            .padding(.vertical, 2)
            .background(Color("secondary-color"), in: Capsule())
    }
}

struct CategoryCapsule_Previews: PreviewProvider {
    static var previews: some View {
        CategoryCapsule(categoryName: "Pop")
    }
}
