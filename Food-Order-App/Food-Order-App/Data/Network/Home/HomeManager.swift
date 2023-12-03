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
    
    // I marked the method as .post because i sent a parameter. If there was no parameter i would have marked it as .get. !!!!!!!
    func loadCart(params: Parameters, completion: @escaping ([GetFoodsFromCart]?, Error?) -> () ) {
        let url = HomeEndPoint.getFoodsFromCart.path
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
}

// .failure error ise baglanti hatasi olustu
// success olup error olursa cart empty hatasi versin.
// completionlari mi ayiririz artik bilemem
// bu olmuyo cunku api desteklemiyo. empty cart error'u ayrilmiyo cunku success = 0 donuyo cart bos ise.



