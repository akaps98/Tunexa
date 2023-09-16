//
//  Artist.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 13/09/2023.
//

import Foundation
import SwiftUI

struct Artist: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var job: String
    var avatarName: String
    var avatar: Image {
        Image(avatarName)
    }
}
