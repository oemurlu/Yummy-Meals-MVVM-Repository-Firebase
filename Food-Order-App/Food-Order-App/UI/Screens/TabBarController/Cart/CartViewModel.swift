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
}

class CartViewModel {
    
    var repo = UserRepository()
    weak var delegate: CartViewModelProtocol?
    
    var cartFoods = [GetFoodsFromCart]() {
        didSet {
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
}
