//
//  CartHelper.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 3.12.2023.
//

import Foundation

enum CartEndPoint: String {
    case getFoodsFromCart = "sepettekiYemekleriGetir"
    case deleteFoodFromCart = "sepettenYemekSil"

    var path: String {
        switch self {
        case .getFoodsFromCart:
            return NetworkHelper.shared.requestFinalUrl(url: CartEndPoint.getFoodsFromCart.rawValue)
        case .deleteFoodFromCart:
            return NetworkHelper.shared.requestFinalUrl(url: CartEndPoint.deleteFoodFromCart.rawValue)

        }
    }
}
