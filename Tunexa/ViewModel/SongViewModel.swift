/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: Seongjoon Hong
  ID: 3726123
  Created  date: 13/09/2023
  Last modified: dd/09/2023
  Acknowledgement: https://firebase.google.com/docs/storage/ios/upload-files
 https://firebase.google.com/docs/storage/ios/delete-files
 https://firebase.google.com/docs/firestore/solutions/swift-codable-data-mapping
 https://stackoverflow.com/questions/75041939/using-imagepicker-in-swiftui
*/
//
//  SongViewModel.swift
//  Tunexa
//
//  Created by SeongJoon, Hong  on 13/09/2023.
//

import CoreData
import FirebaseFirestore
import FirebaseStorage

class SongViewModel: ObservableObject{
    @Published var songs = [Song]()

        private var db = Firestore.firestore()
        
        init() {
            getAllSongData()
        }
        
    // Fetch all Songs in the database
    func getAllSongData() {
        db.collection("songs").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
                
            self.songs = documents.map { (queryDocumentSnapshot) -> Song in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let author = data["author"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let avatarName = data["avatarName"] as? String ?? ""
                let songURL = data["songURL"] as? String ?? ""
                let categories = data["categories"] as? [String] ?? [""]
                return Song(id: id, author: author, name: name, songURL: songURL, avatarName: avatarName, categories: categories)
            }
        }
    }

    // Add new song to the database
    func addNewSongData(author: String, name: String, avatar: Data, categories: [String]) {
        let data = avatar
        let storageRef = Storage.storage().reference()
        let songRef = storageRef.child("songs/\(name)-\(author).mp3")
        let avatarRef = storageRef.child("album_covers/\(name)-\(author).png")
        var songUrl = ""
        if let path = Bundle.main.url(forResource: name, withExtension: "mp3"){
            _ = songRef.putFile(from: path, metadata: nil){ (metadata, error) in
                guard metadata != nil else {
                return
              }
                songRef.downloadURL{ (url, error) in
                    guard let downloadURL = url else {
                        return
                    }
                      songUrl = downloadURL.absoluteString
                    _ = avatarRef.putData(data, metadata: nil) { (metadata, error) in
                        guard metadata != nil else {
                        return
                      }
                      avatarRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                          return
                        }
                          print("URL: \(songUrl)")
                          self.db.collection("songs").addDocument(data: ["author": author, "name": name, "songURL": songUrl, "avatarName": downloadURL.absoluteString, "categories": categories])
                      }
                    }
                }
            }
        }
        
    }
    
    // Delete a song
    func deleteSongData(id: String, name: String, author: String){
        let storageRef = Storage.storage().reference()
        let avatarRef = storageRef.child("album_covers/\(name)-\(author).png")
        let songRef = storageRef.child("songs/\(name)-\(author).mp3")
        songRef.delete{ err in
            if let err = err {
                print("Error \(err)")
            }else{
                print("Deleted Successfully")
            }
        }
        avatarRef.delete{ err in
            if let err = err {
                print("Error \(err)")
            }else{
                print("Deleted Successfully")
            }
        }
        db.collection("songs").document(id).delete(){ err in
            if let err = err {
                print("Error removing the data \(err)")
            }else{
                print("Deleted Successfully!")
            }
        }
    }
    
    // Update attributes of a song document except image
    func updateSongData(id: String, author: String, name: String, categories: [String]){
        db.collection("songs").document(id).updateData(["author": author, "name": name, "categories": categories])
    }
    
    // Update image of a song
    func updateImage(id: String, name: String, avatar: Data){
        let storageRef = Storage.storage().reference()
        let avatarRef = storageRef.child("album_covers/\(name).png")
        _ = avatarRef.putData(avatar, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
            return
          }
          avatarRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
                print("asfasfas")
              return
            }
              self.db.collection("songs").document(id).updateData(["avatarName": downloadURL.absoluteString])
          }
        }
    }
}
