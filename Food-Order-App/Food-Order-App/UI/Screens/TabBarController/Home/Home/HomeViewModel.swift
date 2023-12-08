//
//  HomeViewModel.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 30.11.2023.
//

import Foundation

protocol HomeViewModelProtocol: AnyObject {
    func foodsDidLoad()
}

class HomeViewModel {
    
    var repo = UserRepository()
    weak var delegate: HomeViewModelProtocol?
    
    var foodsList = [Foods]() {
        didSet {
            delegate?.foodsDidLoad()
        }
    }
    
    var filteredList = [Foods]() {
        didSet {
            delegate?.foodsDidLoad()
        }
    }
    
    init() {
        loadFoods()
    }
    
    func loadFoods() {
        repo.loadAllFoods { [weak self] foods in
            self?.foodsList = foods
            self?.filteredList = foods
        }
    }
    
    func addFoodToCart(foodName: String, foodImageName: String, foodPrice: Int, foodOrderCount: Int) {
        repo.addFoodToCart(foodName: foodName, foodImageName: foodImageName, foodPrice: foodPrice, foodOrderCount: foodOrderCount) {
            print("food added to cart")
        }
    }
    
    func searchBarTextDidChange(text: String) {
        if text != "" {
            filteredList = foodsList.filter { food in
                if let foodName = food.yemek_adi {
                    return foodName.lowercased().contains(text.lowercased())
                }
            return true
            }
        } else {
            filteredList = foodsList
        }
    }
}
