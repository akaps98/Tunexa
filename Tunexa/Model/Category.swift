//
//  Category.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 13/09/2023.
//

import Foundation
import SwiftUI

struct Category: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var imageName: String
    var image: Image {
        Image(imageName)
    }
}
