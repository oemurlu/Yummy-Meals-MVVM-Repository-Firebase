//
//  FoodViewModel.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 7.12.2023.
//

import Foundation

protocol FoodDetailViewModelProtocol: AnyObject {
    func quantityChanged(quantity: Int)
    func foodPriceChanged(price: Int)
    func addFoodToCart()
}

class FoodVDetailviewModel {
    
    weak var delegate: FoodDetailViewModelProtocol?
    
    var food: Foods?
//    var repo = UserRepository()
    private let repo: UserRepository
    
    init(repo: UserRepository) {
        self.repo = repo
    }
    
    var quantityOfOrder: Int? = 1 {
        didSet {
            calculateFoodPriceWithQuantity()
            delegate?.quantityChanged(quantity: quantityOfOrder ?? 1)
        }
    }
    
    var foodPrice: Int? = 0 {
        didSet {
            delegate?.foodPriceChanged(price: foodPrice ?? 0)
        }
    }
    
    func calculateFoodPriceWithQuantity() {
        if let quantityOfOrder = quantityOfOrder, let foodPrice = Int((food?.yemek_fiyat)!) {
            self.foodPrice = quantityOfOrder * foodPrice
        }
    }
    
    // there is no rating info on the api. So, i'm creating random ratings.
    func randomBetween3_5And5_0() -> String {
        let randomValue = Double.random(in: 3.8..<5.0)
        return String(format: "%.1f", randomValue)
    }
    
    func decreaseQuantity() {
        guard var quantity = quantityOfOrder, quantity > 1 else { return }
        quantity -= 1
        self.quantityOfOrder = quantity
    }
    
    func increaseQuantity() {
        guard var quantity = quantityOfOrder, quantity > 0 else { return }
        quantity += 1
        self.quantityOfOrder = quantity
    }
    
    func addToCart() {
        if let food = food,
           let name = food.yemek_adi,
           let imageName = food.yemek_resim_adi,
           let priceString = food.yemek_fiyat,
           let price = Int(priceString),
           let orderCount = quantityOfOrder {
            
            repo.addOrIncreaseFoodInCart(foodName: name, foodImageName: imageName, foodPrice: price, foodOrderCount: orderCount) {
                self.delegate?.addFoodToCart()
            }
        }
    }
}
