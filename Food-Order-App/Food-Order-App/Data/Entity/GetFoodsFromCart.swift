//
//  GetFoodsFromCart.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 3.12.2023.
//

import Foundation

struct GetFoodsFromCart: Codable {
    var sepet_yemek_id: String?
    var yemek_adi: String?
    var yemek_resim_adi: String?
    var yemek_fiyat: String?
    var yemek_siparis_adet: String?
    var kullanici_adi: String?
}

struct GetFoodsFromCartResponse: Codable {
    var sepet_yemekler: [GetFoodsFromCart]?
    var success: Int?
}
