//
//  FavoritesViewModel.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 12.12.2023.
//

import Foundation

protocol FavoritesViewModelProtocol: AnyObject {
    func foodsDidLoad()
}

class FavoritesViewModel {
    
    var favoriteFoods = [Foods]() {
        didSet {
            delegate?.foodsDidLoad()
        }
    }
    
    weak var delegate: FavoritesViewModelProtocol?
}
