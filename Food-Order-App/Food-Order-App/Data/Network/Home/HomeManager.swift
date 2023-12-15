//
//  HomeManager.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 1.12.2023.
//

import Foundation
import Alamofire

class HomeManager {
    static let shared = HomeManager()
    
    private init() {}
    
    func loadAllFoods(completion: @escaping ([Foods]) -> ()) {
        let url = HomeEndPoint.loadAllFoods.path
        NetworkManager.shared.request(url: url, method: .get) { (result: Result<FoodsResponse, Error>) in
            switch result {
            case .success(let response):
                if let foods = response.yemekler {
                    completion(foods)
                } else {
                    print("loadAllFoods error on userRepository")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func addFoodToBasket(params: Parameters, completion: @escaping (Int) -> ()) {
        let url = HomeEndPoint.addFoodToCart.path
        NetworkManager.shared.request(url: url, method: .post, parameters: params) { (result: Result<AddFoodToCartResponse, Error>) in
            switch result {
            case .success(let response):
                completion(response.success!)
            case .failure(let error):
                print("HomeManager addFoodToBasketError: \(error.localizedDescription)")
                // TODO: completion = "the cart is empty"
            }
        }
    }
}


