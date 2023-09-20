//
//  User.swift
//  Tunexa
//
//  Created by Christina Yoo on 15/09/2023.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct User: Identifiable, Codable {
    var id: String?
    var email: String
    var name: String
    var description: String
    var pictureName: String
    var playlist: [String]
    var favorite: [String]
    
    // fetch user's information from firebase
    static func fetch(completion: @escaping (Result<User, Error>) -> Void) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "", code: 401, userInfo: nil)))
            return
        }

        let db = Firestore.firestore()
        let userRef = db.collection("UserInfo").document(currentUserUID)

        userRef.getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let document = document, document.exists {
                if let data = document.data() {
                    let user = User(
                        id: document.documentID,
                        email: data["email"] as? String ?? "",
                        name: data["name"] as? String ?? "",
                        description: data["description"] as? String ?? "",
                        pictureName: data["pictureName"] as? String ?? "",
                        playlist: data["playlist"] as? [String] ?? [],
                        favorite: data["favorite"] as? [String] ?? []
                    )
                    completion(.success(user))
                } else {
                    completion(.failure(NSError(domain: "", code: 500, userInfo: nil)))
                }
            } else {
                completion(.failure(NSError(domain: "", code: 404, userInfo: nil)))
            }
        }
    }
    
    // update description and username of the user
    static func updateProfile(newDesc: String, newName: String, completion: @escaping (Error?) -> Void) {
        
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            completion(NSError(domain: "", code: 401, userInfo: nil))
            return
        }
        
        let db = Firestore.firestore()
        let userInfoCollection = db.collection("UserInfo")
        
        let dataToUpdate: [String: Any] = [
            "description": newDesc,
            "name": newName
        ]

        userInfoCollection.document(currentUserUID).updateData(dataToUpdate) { error in
            if let error = error {
                print("Error updating user profile: \(error.localizedDescription)")
                completion(error)
            } else {
                print("User profile updated successfully.")
                completion(nil)
            }
        }
    }
    
    
    // upload profile image to storage and update user's pictureName field accordingly
    static func updateImage(avatar: Data, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            print("error 1")
            completion(.failure(NSError(domain: "", code: 401, userInfo: nil)))
            return
        }
        
        let db = Firestore.firestore()
        let userInfoCollection = db.collection("UserInfo")
        
        let storageRef = Storage.storage().reference()
        let avatarRef = storageRef.child("profile_images/user_\(currentUserUID).png")
        
        avatarRef.putData(avatar, metadata: nil) { (metadata, error) in
            if let error = error {
                print("error 2")
                completion(.failure(error))
            } else {
                avatarRef.downloadURL { (url, error) in
                    if let downloadURL = url {
                        userInfoCollection.document(currentUserUID).updateData(["pictureName": downloadURL.absoluteString]) { error in
                            if let error = error {
                                print("error 3")
                                completion(.failure(error))
                            } else {
                                print("good")
                                completion(.success(downloadURL))
                            }
                        }
                    } else {
                        if let error = error {
                            print("error 0")
                            completion(.failure(error))
                        } else {
                            print("error 01")
                            completion(.failure(NSError(domain: "", code: 500, userInfo: nil)))
                        }
                    }
                }
            }
        }
    }

    // add the song's id to user's favorite array field
    static func addToFavorite(songID: String, completion: @escaping (Error?) -> Void) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            completion(NSError(domain: "", code: 401, userInfo: nil))
            return
        }

        let db = Firestore.firestore()
        let userInfoCollection = db.collection("UserInfo")

        userInfoCollection.document(currentUserUID).updateData([
            "favorite": FieldValue.arrayUnion([songID])
        ]) { error in
            if let error = error {
                print("Error adding to favorite: \(error.localizedDescription)")
                completion(error)
            } else {
                print("Added to favorite successfully.")
                completion(nil)
            }
        }
    }
    
    // delete the song's id from user's favorite array field
    static func deleteFromFavorite(songID: String, completion: @escaping (Error?) -> Void) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            completion(NSError(domain: "", code: 401, userInfo: nil))
            return
        }

        let db = Firestore.firestore()
        let userInfoCollection = db.collection("UserInfo")

        userInfoCollection.document(currentUserUID).updateData([
            "favorite": FieldValue.arrayRemove([songID])
        ]) { error in
            if let error = error {
                print("Error deleting from favorite: \(error.localizedDescription)")
                completion(error)
            } else {
                print("Deleted from favorite successfully.")
                completion(nil)
            }
        }
    }
    
    // add the song's id to user's playlist array field
    static func addToPlaylist(songID: String, completion: @escaping (Error?) -> Void) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            completion(NSError(domain: "", code: 401, userInfo: nil))
            return
        }

        let db = Firestore.firestore()
        let userInfoCollection = db.collection("UserInfo")

        userInfoCollection.document(currentUserUID).updateData([
            "playlist": FieldValue.arrayUnion([songID])
        ]) { error in
            if let error = error {
                print("Error adding to playlist: \(error.localizedDescription)")
                completion(error)
            } else {
                print("Added to playlist successfully.")
                completion(nil)
            }
        }
    }
    
    // delete the song's id from user's playlist array field
    static func deleteFromPlaylist(songID: String, completion: @escaping (Error?) -> Void) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            completion(NSError(domain: "", code: 401, userInfo: nil))
            return
        }

        let db = Firestore.firestore()
        let userInfoCollection = db.collection("UserInfo")

        userInfoCollection.document(currentUserUID).updateData([
            "playlist": FieldValue.arrayRemove([songID])
        ]) { error in
            if let error = error {
                print("Error deleting from playlist: \(error.localizedDescription)")
                completion(error)
            } else {
                print("Deleted from playlist successfully.")
                completion(nil)
            }
        }
    }

}
