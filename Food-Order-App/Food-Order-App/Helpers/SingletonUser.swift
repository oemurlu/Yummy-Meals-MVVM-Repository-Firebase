//
//  SingletonUser.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 16.12.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class SingletonUser {
    static let shared = SingletonUser()
    
    private init() {} // disa aktarma kapali

    func getUserUid() -> String {
        guard let user = Auth.auth().currentUser else { return "" }
        let userUid = user.uid
        return userUid
    }
    
    func getUserName(completion: @escaping (String) -> Void) {
        let collectionUsers = Firestore.firestore().collection("Users").document(getUserUid()).getDocument { document, error in
            if let error = error {
                print("Error in getUserName: \(error.localizedDescription)")
                completion("test") // Provide a default value in case of an error
            } else {
                guard let document = document, document.exists else {
                    completion("test") // Provide a default value if the document does not exist
                    return
                }
                if let fullName = document.get("fullName") as? String {
                    let firstName = fullName.components(separatedBy: " ").first ?? fullName
                    completion(firstName)
                } else {
                    completion("test") // Provide a default value if fullName is not a string
                }
            }
        }
    }
}
