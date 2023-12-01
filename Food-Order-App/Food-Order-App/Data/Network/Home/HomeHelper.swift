//
//  HomeHelper.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 1.12.2023.
//

import Foundation

enum HomeEndPoint: String {
    case loadAllFoods = "tumYemekleriGetir"
    
    var path: String {
        switch self {
        case .loadAllFoods:
            return NetworkHelper.shared.requestFinalUrl(url: HomeEndPoint.loadAllFoods.rawValue)
        }
    }
}
