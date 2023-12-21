//
//  ProfileManager.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 18.12.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class ProfileManager {
    static let shared = ProfileManager()
    private let storage = Storage.storage()
    let collectionUsers = Firestore.firestore().collection("Users")
    
    private init() {}
    
    func fetchUserInfosFromFirebase(completion: @escaping (String, String, String, String) -> ()) {
        let userUid = SingletonUser.shared.getUserUid()
        let collectionUsers = Firestore.firestore().collection("Users").document(userUid).getDocument { document, error in
            if let error = error {
                print("Error in getUserName: \(error.localizedDescription)")
            } else {
                guard let document = document, document.exists else { return }
                
                if let userName = document.get("username") as? String,
                   let fullName = document.get("fullName") as? String,
                   let email = document.get("email") as? String,
                   let phoneNumber = document.get("phoneNumber") as? String {
                    completion(userName, fullName, email, phoneNumber)
                } else {
                    // default values
                    completion("defaultUserName", "defaultFullName", "defaultEmail", "defaultPhoneNumber")
                }
            }
        }
    }
    
    
    func fetchProfilePhotoFromFirebase(userUid: String, completion: @escaping (Data) -> ()) {
        collectionUsers.document(userUid).getDocument { document, error in
            if error != nil {
                print("failed to connect firebase for fetch profile photo")
                return
            }
            
            guard let document = document, document.exists else { return }
            if let profilePhotoUrl = document.get("profilePhotoUrl") as? String {
                let storageRef = self.storage.reference(forURL: profilePhotoUrl)
                storageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                    if error != nil {
                        print("error while downloading profile photo: \(error?.localizedDescription)")
                        return
                    }
                    
                    guard let imageData = data else { return }
                    completion(imageData)
                }
            }
        }
    }
    
    func uploadProfilePhotoToFirebase(image: UIImage, userUid: String) {
        guard let imageData = image.jpegData(compressionQuality: 0.1) else { return }
        
        let storageRef = storage.reference().child("profile_photos").child("\(String(describing: userUid)).jpg")
        let uploadTask = storageRef.putData(imageData) { metaData, error in
            if error != nil {
                print("upload error: \(error?.localizedDescription)")
                return
            }
            
            storageRef.downloadURL { result in
                switch result {
                case .success(let url):
                    // Save the downloadUrl to firestore
                    self.collectionUsers.document(userUid).setData(["profilePhotoUrl": url.absoluteString], merge: true) { error in
                        if let error = error {
                            print("error while uploading photo to Firestore: \(error.localizedDescription)")
                        } else {
                            print("photo url saved to firestore successfully.")
                        }
                    }
                case .failure(let error):
                    print("download photo url couldn't get, error: \(error.localizedDescription)")
                }
            }
        }
        uploadTask.resume()
    }
}
