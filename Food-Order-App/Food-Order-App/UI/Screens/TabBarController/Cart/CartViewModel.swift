//
//  CartViewModel.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 3.12.2023.
//

import Foundation

protocol CartViewModelProtocol: AnyObject {
    func foodsDidLoad()
    func foodDeleted()
    func foodQuantityUpdated()
}

class CartViewModel {
    
    var repo = UserRepository()
    weak var delegate: CartViewModelProtocol?
    
    var cartFoods = [GetFoodsFromCart]() {
        didSet {
            cartFoods.sort(by: {Int($0.yemek_fiyat!)! < Int($1.yemek_fiyat!)!})
            delegate?.foodsDidLoad()
        }
    }
    
    func loadFoods() {
        repo.loadFoodsFromCart { [weak self] foods in
            self?.cartFoods = foods
        }
    }
    
    func deleteItemFromCart(foodOrderId: String) {
        repo.deleteItemFromCart(foodCartId: foodOrderId) {
            self.delegate?.foodDeleted()
        }
    }
    
    func updateQuantity(index: IndexPath, newQuantity: Int) {
        var food = cartFoods[index.section]
        food.yemek_siparis_adet = "\(newQuantity)"
        repo.updateQuantity(food: food) {
            self.delegate?.foodQuantityUpdated()
        }
    }
}
