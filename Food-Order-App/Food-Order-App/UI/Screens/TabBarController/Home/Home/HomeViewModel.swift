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
    
//    var repo = UserRepository()
    private let repo: UserRepository
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
    
    init(repo: UserRepository) {
        self.repo = repo
        loadFoods()
    }
    
    func loadFoods() {
        repo.loadAllFoods { [weak self] foods in
            self?.foodsList = foods
            self?.filteredList = foods
        }
    }
    
    func addFoodToCart(foodName: String, foodImageName: String, foodPrice: Int, foodOrderCount: Int) {
        repo.addOrIncreaseFoodInCart(foodName: foodName, foodImageName: foodImageName, foodPrice: foodPrice, foodOrderCount: foodOrderCount) {
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
