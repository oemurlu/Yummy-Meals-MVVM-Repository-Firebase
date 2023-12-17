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
}
