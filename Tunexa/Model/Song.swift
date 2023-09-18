/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: Seongjoon Hong
  ID: 3726123
  Created  date: 16/09/2023
  Last modified: 18/09/2023
  Acknowledgement:
*/
//
//  Song.swift
//  Tunexa
//
//  Created by SeongJoon, Hong  on 16/09/2023.
//

import Foundation
import FirebaseFirestoreSwift

struct Song: Codable, Identifiable, Hashable{
    @DocumentID var id: String?
    var author: String?
    var name: String?
    var songURL: String?
    var avatarName: String?
    var categories: [String]
}
