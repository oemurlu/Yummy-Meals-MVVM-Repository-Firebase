//
//  ProfileManager.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 18.12.2023.
//

import Foundation
import FirebaseFirestore

class ProfileManager {
    static let shared = ProfileManager()
    
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
    
}
