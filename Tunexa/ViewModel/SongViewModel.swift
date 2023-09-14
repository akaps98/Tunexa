// https://firebase.google.com/docs/storage/ios/upload-files
// https://firebase.google.com/docs/storage/ios/delete-files
// https://firebase.google.com/docs/firestore/solutions/swift-codable-data-mapping
// https://stackoverflow.com/questions/75041939/using-imagepicker-in-swiftui
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

    func addNewSongData(author: String, name: String, songURL: String, avatar: Data, categories: [String]) {
        let data = avatar
        let storageRef = Storage.storage().reference()
        let avatarRef = storageRef.child("album_covers/\(name).png")
        
        _ = avatarRef.putData(data, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
            return
          }
          avatarRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
                print("asfasfas")
              return
            }
              self.db.collection("songs").addDocument(data: ["author": author, "name": name, "songURL": songURL, "avatarName": downloadURL.absoluteString, "categories": categories])
          }
        }
    }
    
    func deleteSongData(id: String, name: String){
        let storageRef = Storage.storage().reference()
        let avatarRef = storageRef.child("album_covers/\(name).png")
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
                print("Delted Successfully!")
            }
        }
    }
    
    func updateSongData(id: String, author: String, name: String, songURL: String, categories: [String]){
        db.collection("songs").document(id).updateData(["author": author, "name": name, "songURL": songURL, "categories": categories])
    }
    
    func updateImage(id: String, name: String, avatar: Data){
        let storageRef = Storage.storage().reference()
        let avatarRef = storageRef.child("album_covers/\(name).png")
//        avatarRef.delete{ err in
//            if let err = err {
//                print("Error \(err)")
//            }else{
//                print("Deleted Successfully")
//            }
//        }
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
