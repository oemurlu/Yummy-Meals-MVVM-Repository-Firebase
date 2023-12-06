//
//  CartManager.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 3.12.2023.
//

import Foundation
import Alamofire

class CartManager {
    static let shared = CartManager()
    
    private init() {}
    
    // I marked the method as .post because i sent a parameter. If there was no parameter i would have marked it as .get !!!!!!!
    func loadCart(params: Parameters, completion: @escaping ([GetFoodsFromCart]?, Error?) -> () ) {
        let url = CartEndPoint.getFoodsFromCart.path
        NetworkManager.shared.request(url: url, method: .post, parameters: params) { (result: Result<GetFoodsFromCartResponse, Error>) in
            switch result {
            case .success(let response):
                if let foods = response.sepet_yemekler, !foods.isEmpty {
                    completion(foods, nil)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func deleteFoodFromCart(params: Parameters, completion: @escaping () -> ()) {
        let url = CartEndPoint.deleteFoodFromCart.path
        NetworkManager.shared.request(url: url, method: .post, parameters: params) { (result: Result<DeleteFoodFromCartResponse, Error>) in
            switch result {
            case .success(let message):
//                print("message: \(message)")
                completion()
            case .failure(let error):
                print("deleteFoodFromCartError: \(error.localizedDescription)")
                completion()
            }
        }
    }
}
