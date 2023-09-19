//
//  Song.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 13/09/2023.
//

import Foundation
import SwiftUI

struct Song: Identifiable, Codable, Hashable {
    var id: Int
    var name: String
    var author: String
    var categories: [String]
    var rating: Int
    var songURL: String
    var avatarName: String
    var avatar: Image {
        Image(avatarName)
    }
}
