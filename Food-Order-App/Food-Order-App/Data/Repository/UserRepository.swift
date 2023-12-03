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
    var allFoods: [Foods] = []
    let homeManager = HomeManager.shared
    
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
    
    // v1 request directly
//    func loadFoods(completion: @escaping ([Foods]) -> ()) {
//        AF.request("http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php", method: .get).response { response in
//            if let data = response.data {
//                do {
//                    let response = try JSONDecoder().decode(FoodsResponse.self, from: data)
//                    if let foods = response.yemekler {
//                        completion(foods)
//                    } else {
//                        print("loadFoods error on userRepository")
//                    }
//                } catch {
//                    print(error.localizedDescription)
//                }
//            }
//        }
//    }

    // v2 request from network manager
//    func loadFoods(completion: @escaping ([Foods]) -> ()) {
//        let networkManager = NetworkManager.shared
//        networkManager.request(url: "tumYemekleriGetir", method: .get) { (result: Result<FoodsResponse, Error>) in
//            switch result {
//            case .success(let response):
//                if let foods = response.yemekler {
//                    completion(foods)
//                } else {
//                    print("loadFoods error on userRepository")
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    // v3: make request from homeManager and homeManager requests from NetworkManager
    func loadAllFoods(completion: @escaping ([Foods]) -> ()) {
        homeManager.loadAllFoods { [weak self] foods in
            self?.allFoods = foods
            completion(foods)
        }
    }
    
    func addFoodToCart(foodName: String, foodImageName: String, foodPrice: Int, foodOrderCount: Int) {
        let params: Parameters = ["yemek_adi": foodName, "yemek_resim_adi": foodImageName, "yemek_fiyat": foodPrice, "yemek_siparis_adet": foodOrderCount, "kullanici_adi": "oe4" ]
        
        homeManager.addFoodToBasket(params: params) { succes in
            print("repo callback success value: \(succes)")
        }
    }
    
    func getFoodsFromCart() {
        let params: Parameters = ["kullanici_adi": "oe5"]
        homeManager.loadCart(params: params) { foods, error in
            if let error = error {
                print("your card is empty")
            } else {
                guard let foods = foods else {
                    print("error: cart data is nil")
                    return
                }
                for food in foods {
                    print(food.kullanici_adi!)
                    print(food.sepet_yemek_id!)
                    print(food.yemek_adi!)
                    print("*******")
                }
            }
        }
    }
    
    // actually this function is so basic and bad. Before this function, I wrote a better function which is seperating errors by connection error or empty card error but this api doesn't supoort empty card message. If the user has item in the cart, the api returns foods and succes: 1 and sepet_yemekler = [Foods] but if the user dont have item in the cart, the api returns success: 0 and sepet_yemekler = nil. So i cant handle the errors.
    
}
