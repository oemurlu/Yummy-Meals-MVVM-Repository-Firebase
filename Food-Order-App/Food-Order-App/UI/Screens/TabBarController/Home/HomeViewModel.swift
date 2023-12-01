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
    
    init() {
        loadFoods()
    }
    
    func loadFoods() {
        repo.loadAllFoods { [weak self] foods in
            self?.foodsList = foods
        }
    }
}
