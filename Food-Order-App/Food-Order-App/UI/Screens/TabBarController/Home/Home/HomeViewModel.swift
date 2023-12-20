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
    
    func loadFoodsByFilter(filter: FilterBy) {
        var foods = self.filteredList
        switch filter {
        case .todaysOffers:
            self.filteredList = self.foodsList
        case .ascending:
            let sortedByPriceAscending = foods.sorted { (food1, food2) -> Bool in
                guard let price1 = food1.yemek_fiyat, let price2 = food2.yemek_fiyat else {
                    return false
                }
                return Double(price1) ?? 0 < Double(price2) ?? 0
            }
            self.filteredList = sortedByPriceAscending
        case .descending:
            let sortedByPriceDescending = foods.sorted { (food1, food2) -> Bool in
                guard let price1 = food1.yemek_fiyat, let price2 = food2.yemek_fiyat else {
                    return false
                }
                return Double(price1) ?? 0 > Double(price2) ?? 0
            }
            self.filteredList = sortedByPriceDescending
        case .aToZ:
            let sortedByNameAtoZ = foods.sorted { $0.yemek_adi ?? "" < $1.yemek_adi ?? "" }
            self.filteredList = sortedByNameAtoZ
        case .zToA:
            let sortedByNameZtoA = foods.sorted { $0.yemek_adi ?? "" > $1.yemek_adi  ?? "" }
            self.filteredList = sortedByNameZtoA
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
    
    func getUserName(completion: @escaping (String) -> ()) {
        SingletonUser.shared.getUserName { name in
            completion(name)
        }
    }
}
