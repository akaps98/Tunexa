/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Team: Squad 21 (Group 21)
  Members:
  1. Nguyen Anh Duy (s3878141)
  2. Seoungjoon Hong (s3726123)
  3. Junsik Kang (s3916884) - Main Contributor
  4. Christina Yoo (s3938331)
  5. Nguyen Hoang Viet (s3926104)
  Created date: 17/09/2023
  Last modified: 17/09/2023
  Acknowledgement: None
*/

import SwiftUI

struct Rating: View {
    // MARK: ***** PROPERTIES *****
    @State var rating: Int

    var maximum = 5
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color("light-gray")
    var onColor = Color("primary-color")
    
    /**
     Function: generater star icons for rating
     */
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
    
    var body: some View {
        // MARK: STAR RATING ROW
        HStack {
            ForEach(1..<maximum + 1, id: \.self) { number in
                image(for: number)
                    .font(.system(size: 12))
                    .foregroundColor(number > rating ? offColor : onColor)
            }
        }
    }
}

struct Rating_Previews: PreviewProvider {
    static var previews: some View {
        Rating(rating: 4)
    }
}
