//
//  CartViewModel.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 3.12.2023.
//

import Foundation

protocol CartViewModelProtocol: AnyObject {
    func foodsDidLoad()
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
    
    
}
