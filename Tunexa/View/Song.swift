/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Team: Squad 21 (Group 21)
  Members:
  1. Nguyen Anh Duy (s3878141) - Sub Contributor
  2. Seoungjoon Hong (s3726123) - Main Contributor
  3. Junsik Kang (s3916884)
  4. Christina Yoo (s3938331)
  5. Nguyen Hoang Viet (s3926104) - Sub Contributor
  Created date: 13/09/2023
  Last modified: 18/09/2023
  Acknowledgement: None
*/

import Foundation
import FirebaseFirestoreSwift

struct Song: Codable, Identifiable, Hashable{
    @DocumentID var id: String?
    var author: [String?]
    var name: String?
    var songURL: String?
    var avatarName: String?
    var categories: [String]
    var rating: Int?
}
