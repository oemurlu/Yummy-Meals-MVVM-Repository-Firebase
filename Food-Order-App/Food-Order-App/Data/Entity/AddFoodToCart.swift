//
//  addFoodToCart.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 3.12.2023.
//

import Foundation

//struct AddFoodToCart: Codable {
//    var yemek_adi: String?
//    var yemek_resim_adi: String?
//    var yemekL_fiyat: Int?
//    var yemek_siparis_adet: Int?
//    var kullanici_adi: String?
//    
//}

struct AddFoodToCartResponse: Codable {
    var success: Int?
    var message: String?
}
