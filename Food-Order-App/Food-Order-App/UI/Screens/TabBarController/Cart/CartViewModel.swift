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
    func updateTotalCartPrice()
    func isCartEmpty(isEmpty: Bool)
    func totalCartPriceChanged(price: Int)
}

class CartViewModel {
    
//    var repo = UserRepository()
    private let repo: UserRepository
    weak var delegate: CartViewModelProtocol?
    var totalCartPrice: Int = 0
    
    var cartFoods = [GetFoodsFromCart]() {
        didSet {
            cartFoods.sort(by: {Int($0.yemek_fiyat!)! < Int($1.yemek_fiyat!)!})
            delegate?.foodsDidLoad()
            self.isCartEmpty()
            self.calculateTotalCartPrice()
        }
    }
    
    init(repo: UserRepository) {
        self.repo = repo
    }
    
    func isCartEmpty() {
        if cartFoods.count == 0 {
            print("your cart is empty.")
            delegate?.isCartEmpty(isEmpty: true)
        } else {
            delegate?.isCartEmpty(isEmpty: false)
        }
    }
    
    func loadFoods() {
        repo.loadFoodsFromCart { [weak self] foods in
            if let foods = foods {
                self?.cartFoods = foods
            } else {
                self?.cartFoods = [GetFoodsFromCart]()
                self?.delegate?.updateTotalCartPrice()
            }
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
    
    func calculateTotalCartPrice() {
        self.totalCartPrice = 0
        for food in cartFoods {
            if let orderQuantity = Int(food.yemek_siparis_adet ?? "1"), let price = Int(food.yemek_fiyat ?? "0") {
                let foodTotalPrice = orderQuantity * price
                self.totalCartPrice += foodTotalPrice
            }
        }
        delegate?.totalCartPriceChanged(price: self.totalCartPrice)
    }
}
