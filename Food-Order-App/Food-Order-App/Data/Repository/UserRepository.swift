//
//  emptyFileForGit2.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 4.11.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Alamofire

class UserRepository {
    
    let db = Firestore.firestore()
    let collectionUsers = Firestore.firestore().collection("Users")
    
    func createUser(email: String, pw: String, completion: @escaping (Result<AuthDataResult, Error>) -> (Void)) {
        Auth.auth().createUser(withEmail: email, password: pw) { authResult, error in
            if let error = error {
                // there is an error, returning result with completion handler
                completion(.failure(error))
            } else {
                // user created succesfully, returning result with completion handler
                if let authResult = authResult {
                    completion(.success(authResult))
                }
            }
        }
    }
    
    func signInUser(email: String, pw: String, completion: @escaping (Result<AuthDataResult, Error>) -> (Void)) {
        Auth.auth().signIn(withEmail: email, password: pw) { [weak self] authResult, error in
            guard self != nil else { return }
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(authResult!))
            }
        }
    }
    
    func saveUserInfosToFirestore(username: String, fullName: String, email: String, phoneNumber: String, completion: @escaping (Result<Void, Error>) -> (Void)) {
        let newUser: [String: Any] = ["username": username, "fullName": fullName, "email": email, "phoneNumber": phoneNumber]
        collectionUsers.document().setData(newUser) { error in
            if let error = error {
                print("error saveUserInfosToFirestore on UserRepository: \(error)")
                completion(.failure(error))
            } else {
                completion(.success( () )) // empty succes value
            }
        }
    }
    
    func loadFoods(completion: @escaping ([Foods]) -> ()) {
        AF.request("http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php", method: .get).response { response in
            if let data = response.data {
                do {
                    let response = try JSONDecoder().decode(FoodsResponse.self, from: data)
                    if let foods = response.yemekler {
                        completion(foods)
                    } else {
                        print("loadFoods error on userRepository")
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
}
