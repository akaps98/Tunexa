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
  Created date: 22/09/2023
  Last modified: 22/09/2023
  Acknowledgement: None
*/

import SwiftUI

struct FilterCapsule: View {
    let buttonName: String
    let show: Bool
    
    var body: some View {
        Text(buttonName)
            .modifier(FilterCapsuleModifier())
            .foregroundColor(show ? .white : Color("text-color"))
            .background(Color(show ? "secondary-color" : "light-gray"), in: Capsule())
    }
}

struct FilterCapsule_Previews: PreviewProvider {
    static var previews: some View {
        FilterCapsule(buttonName: "Music", show: false)
    }
}
