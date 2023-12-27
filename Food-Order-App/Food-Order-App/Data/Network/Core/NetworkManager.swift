//
//  NetworkManager.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 1.12.2023.
//

import Foundation
import Alamofire

final class NetworkManager {

    static let shared = NetworkManager()
    
    private init() {}
    //Burada initi private yapmamızın sebebi dışarıdan bir instance oluşturmasını engellemek ve sadece shared üzerinden ulaşılmasını sağlamaktır.
    
    func request<T: Decodable>(url: String, method: HTTPMethod, parameters: Parameters? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(url, method: method, parameters: parameters).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
