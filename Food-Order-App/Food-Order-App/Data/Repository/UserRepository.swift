//
//  emptyFileForGit2.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 4.11.2023.
//

import Foundation
import Alamofire
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class UserRepository {
    
    let db = Firestore.firestore()
    let collectionUsers = Firestore.firestore().collection("Users")
    let homeManager = HomeManager.shared
    let cartManager = CartManager.shared
    let profileManager = ProfileManager.shared
    let currentUser = Auth.auth().currentUser
    let userUid: String = SingletonUser.shared.getUserUid()
    let storage = Storage.storage()
    
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
    
    func saveUserInfosToFirestore(username: String, fullName: String, email: String, phoneNumber: String,userUid: String, completion: @escaping (Result<Void, Error>) -> (Void)) {
        let newUser: [String: Any] = ["username": username, "fullName": fullName, "email": email, "phoneNumber": phoneNumber, "uid": userUid]
        collectionUsers.document(userUid).setData(newUser) { error in
            if let error = error {
                print("error saveUserInfosToFirestore on UserRepository: \(error)")
                completion(.failure(error))
            } else {
                completion(.success( () )) // empty succes value
            }
        }
    }
    
    func loadAllFoods(completion: @escaping ([Foods]) -> ()) {
        homeManager.loadAllFoods { [weak self] foods in
            completion(foods)
        }
    }
    
    func addFoodToCart(foodName: String, foodImageName: String, foodPrice: Int, foodOrderCount: Int, completion: @escaping () -> ()) {
        
        let params: Parameters = ["yemek_adi": foodName, "yemek_resim_adi": foodImageName, "yemek_fiyat": foodPrice, "yemek_siparis_adet": foodOrderCount, "kullanici_adi": userUid]
        
        homeManager.addFoodToBasket(params: params) { success in
            completion()
        }
    }
    
    func addOrIncreaseFoodInCart(foodName: String, foodImageName: String, foodPrice: Int, foodOrderCount: Int, completion: @escaping () -> ()) {
        self.loadFoodsFromCart { [weak self] foods in
            if let existingFood = foods?.first(where: { $0.yemek_adi == foodName }) {
                // If the product is already in the cart, increase the quantity of the available product
                let updatedCount = (existingFood.yemek_siparis_adet?.toInt())! + foodOrderCount
                self?.updateQuantity(food: existingFood, newQuantity: updatedCount, completion: completion)
                    print("quantity updated. newQuantity: \(updatedCount)")
            } else {
                // If the product is not in the cart, add it as a new product
                self?.addFoodToCart(foodName: foodName, foodImageName: foodImageName, foodPrice: foodPrice, foodOrderCount: foodOrderCount, completion: completion)
                print("there is no food in the cart so, food was added to cart.")
            }
        }
    }
        
    
    func loadFoodsFromCart(completion: @escaping ([GetFoodsFromCart]?) -> ()) {
        let params: Parameters = ["kullanici_adi": userUid]
        cartManager.loadCart(params: params) { foods, error in
            if let error = error {
                print("your card is empty: \(error)")
                completion(nil)
            } else {
                guard let foods = foods else {
                    print("error: cart data is nil")
                    return
                }
                completion(foods)
            }
        }
    }
    // actually this function is so basic and bad. Before this function, I wrote a better function which is seperating errors by connection error or empty card error but this api doesn't supoort empty card message. If the user has item in the cart, the api returns foods and succes: 1 and sepet_yemekler = [Foods] but if the user dont have item in the cart, the api returns success: 0 and sepet_yemekler = nil. So i cant handle the errors.
    
    
    
    func deleteItemFromCart(foodCartId: String, completion: @escaping () -> ()) {
        let params: Parameters = ["sepet_yemek_id": foodCartId, "kullanici_adi": userUid, ]
        cartManager.deleteFoodFromCart(params: params) {
            completion()
        }
    }
    
    func updateQuantity(food: GetFoodsFromCart, newQuantity: Int, completion: @escaping () -> ()) {
        if let foodId = food.sepet_yemek_id {
            self.deleteItemFromCart(foodCartId: foodId) {
                self.addFoodToCart(foodName: food.yemek_adi!, foodImageName: food.yemek_resim_adi!, foodPrice: Int(food.yemek_fiyat!)!, foodOrderCount: newQuantity) {
                    completion()
                }
            }
        }
    }
    
    func fetchUserInfosFromFirestore(completion: @escaping (String, String, String, String) -> ()) {
        profileManager.fetchUserInfosFromFirebase { userName, fullName, email, phoneNumber in
            completion(userName, fullName, email, phoneNumber)
        }
    }
    
    func logout(onSucces: @escaping () -> (), onError: (String) -> ()) {
        do {
            try Auth.auth().signOut()
            onSucces()
        } catch let error {
            onError(error.localizedDescription)
        }
    }
    
    func uploadProfilePhotoToFirebase(image: UIImage, onSuccess: @escaping () -> (), onError: @escaping () -> ()) {
//        profileManager.uploadProfilePhotoToFirebase(image: image, userUid: userUid)
        profileManager.uploadProfilePhotoToFirebase(image: image, userUid: userUid) {
            onSuccess()
        } onError: {
            onError()
        }

    }
    
    func fetchProfilePhotoFromFirebase(completion: @escaping (Data) -> ()) {
        profileManager.fetchProfilePhotoFromFirebase(userUid: userUid) { imageData in
            completion(imageData)
        }
    }
}

