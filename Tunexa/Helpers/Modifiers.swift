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
  Created date: 12/09/2023
  Last modified: 22/09/2023
  Acknowledgement:
  - Helper Functions (Modifiers): RMIT Casino Game App - Lecture W6 example from the lecturer (Mr. Tom Huynh)
*/

import Foundation
import SwiftUI

struct FilterCapsuleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Nunito-Medium", size: 16))
            .padding(.horizontal, 25)
            .padding([.top, .bottom], 5)
    }
}

struct TextHeaderModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Nunito-ExtraBold", size: 22))
            .foregroundColor(Color("text-color"))
    }
}
