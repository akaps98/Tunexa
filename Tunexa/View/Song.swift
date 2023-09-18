//
//  Song.swift
//  Tunexa
//
//  Created by SeongJoon, Hong  on 16/09/2023.
//

import Foundation
import FirebaseFirestoreSwift

struct Song: Codable, Identifiable{
    @DocumentID var id: String?
    var author: String?
    var name: String?
    var songURL: String?
    var avatarName: String?
    var categories: [String]
}
