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
import FirebaseStorage

protocol UserRepositoryDelegate: AnyObject {
    func favoriteFoodsDidUpdate(foods: [Foods])
}

class UserRepository {
    
    weak var delegate: UserRepositoryDelegate?
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
            completion(foods)
        }
    }
    
//    func loadAllFoodsByOrder(completion: @escaping ([Foods]) -> ()) {
//        homeManager.loadAllFoods { [weak self] foods in
//            completion(foods)
//        }
//    }

    
    func addFoodToCart(foodName: String, foodImageName: String, foodPrice: Int, foodOrderCount: Int, completion: @escaping () -> ()) {
//        let params: Parameters = ["yemek_adi": foodName, "yemek_resim_adi": foodImageName, "yemek_fiyat": foodPrice, "yemek_siparis_adet": foodOrderCount, "kullanici_adi": "oe7"]
        let params: Parameters = ["yemek_adi": foodName, "yemek_resim_adi": foodImageName, "yemek_fiyat": foodPrice, "yemek_siparis_adet": foodOrderCount, "kullanici_adi": userUid]
        
        homeManager.addFoodToBasket(params: params) { success in
            //            print("repo callback success value: \(success)")
            completion()
        }
    }
    
    func addOrIncreaseFoodInCart(foodName: String, foodImageName: String, foodPrice: Int, foodOrderCount: Int, completion: @escaping () -> ()) {
        self.loadFoodsFromCart { [weak self] foods in
            if let existingFood = foods?.first(where: { $0.yemek_adi == foodName }) {
                // If the product is already in the cart, increase the quantity of the available product
                let updatedCount = (existingFood.yemek_siparis_adet?.toInt())! + foodOrderCount
                self?.updateQuantity(food: existingFood, newQuantity: updatedCount) {
                    print("quantity update edildi. newQuantity: \(updatedCount)")
                }
            } else {
                // If the product is not in the cart, add it as a new product
                self?.addFoodToCart(foodName: foodName, foodImageName: foodImageName, foodPrice: foodPrice, foodOrderCount: foodOrderCount, completion: completion)
                print("urun sepette yok, sepete eklendi")
            }
        }
    }
        
    
    func loadFoodsFromCart(completion: @escaping ([GetFoodsFromCart]?) -> ()) {
        let params: Parameters = ["kullanici_adi": userUid]
        print("loadFoodsFromCart UserUid: \(userUid)")
        cartManager.loadCart(params: params) { foods, error in
            if let error = error {
                print("your card is empty: \(error)")
                completion(nil)
            } else {
                guard let foods = foods else {
                    print("error: cart data is nil")
                    return
                }
                //                for food in foods {
                //                    print(food.kullanici_adi!)
                //                    print(food.sepet_yemek_id!)
                //                    print(food.yemek_adi!)
                //                    print(food.yemek_siparis_adet!)
                //                    print("*******")
                //                }
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
    
    func uploadProfilePhotoToFirebase(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.1) else { return }

        let storageRef = storage.reference().child("profile_photos").child("\(String(describing: userUid)).jpg")
        let uploadTask = storageRef.putData(imageData) { metaData, error in
            if error != nil {
                print("upload error: \(error?.localizedDescription)")
                return
            }
            
            storageRef.downloadURL { url, error in
                if error != nil {
                    print("download url error: \(error?.localizedDescription)")
                    return
                }
                
                let downloadUrl = url?.absoluteString
                print("resmin indirme url'si: \(downloadUrl)")
                
                // save downloadUrl to fireStore
                
                self.collectionUsers.document(self.userUid).setData(["profilePhotoUrl": downloadUrl], merge: true) { error in
                    if error != nil {
                        print("error saving profile photo url to firestore: \(error?.localizedDescription)")
                        return
                    }
                    print("save profile photo url to firestore successfully")
                }
            }
        }
        uploadTask.resume()
    }
    
    func fetchProfilePhotoFromFirebase(completion: @escaping (Data) -> ()) {
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
    
}

