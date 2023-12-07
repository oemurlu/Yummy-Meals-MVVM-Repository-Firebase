//
//  String+Extensions.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 6.12.2023.
//

import Foundation

extension String {
    func toInt() -> Int? {
        guard let integer = Int(self) else { return nil }
        return integer
    }
}
