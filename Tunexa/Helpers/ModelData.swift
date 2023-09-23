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
  Created date: 13/09/2023
  Last modified: 13/09/2023
  Acknowledgement:
  - Parsing data from JSON file into struct: RMIT Contact List - Lab Tutorial W5 example from the lecturer (Mr. Tom Huynh)
*/

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

var categories: [Category] = decodeJsonFromJsonFile(jsonFileName: "category.json")

