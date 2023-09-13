//
//  Song.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 13/09/2023.
//

import Foundation
import SwiftUI

struct Song: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var author: String
    var categories: [String]
    var songURL: String
    var avatarName: String
    var avatar: Image {
        Image(avatarName)
    }
}
