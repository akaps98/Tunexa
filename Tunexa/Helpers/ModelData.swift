//
//  ModelData.swift
//  Tunexa
//
//  Created by Nguyễn Anh Duy on 13/09/2023.
//

import Foundation

/***
  @param T: an object (class or struct) that conforms to Codable  protocol
  @return: an array of T objects
 */
func decodeJsonFromJsonFile<T: Codable>(jsonFileName: String) -> [T] {
    // Check if the file is existed in the directory
    if let file = Bundle.main.url(forResource: jsonFileName, withExtension: nil){
        // Check if the file can be decodable
        if let data = try? Data(contentsOf: file) {
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode([T].self, from: data)
                return decoded
            } catch let error { // Display error message if JSON data is corrupted
                fatalError("Failed to decode JSON: \(error)")
            }
        }
    } else { // Display error message if file cannot found
        fatalError("Couldn't load \(jsonFileName) file")
    }
    return [] as [T]
}

var artists: [Artist] = decodeJsonFromJsonFile(jsonFileName: "artist.json")
var songs: [Song] = decodeJsonFromJsonFile(jsonFileName: "songs.json")
var categories: [Category] = decodeJsonFromJsonFile(jsonFileName: "category.json")

