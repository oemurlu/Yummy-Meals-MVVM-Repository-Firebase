//
//  NetworkHelper.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 1.12.2023.
//

import Foundation

enum NetworkEndPoint: String {
    case base_url = "http://kasimadalan.pe.hu/yemekler/"
}

class NetworkHelper {
    static let shared = NetworkHelper()
    
    func requestFinalUrl(url: String) -> String {
        let finalUrl = "\(NetworkEndPoint.base_url.rawValue)\(url).php"
        return finalUrl
    }
}
