//
//  HomeHelper.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 1.12.2023.
//

import Foundation

enum HomeEndPoint: String {
    case loadAllFoods = "tumYemekleriGetir"
    case addFoodToCart = "sepeteYemekEkle"
    case getFoodsFromCart = "sepettekiYemekleriGetir"
    
    var path: String {
        switch self {
        case .loadAllFoods:
            return NetworkHelper.shared.requestFinalUrl(url: HomeEndPoint.loadAllFoods.rawValue)
        case .addFoodToCart:
            return NetworkHelper.shared.requestFinalUrl(url: HomeEndPoint.addFoodToCart.rawValue)
        case .getFoodsFromCart:
            return NetworkHelper.shared.requestFinalUrl(url: HomeEndPoint.getFoodsFromCart.rawValue)
        }
    }
}
