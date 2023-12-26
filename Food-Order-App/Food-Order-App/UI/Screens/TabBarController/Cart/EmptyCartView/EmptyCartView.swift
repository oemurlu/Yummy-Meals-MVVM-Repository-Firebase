//
//  EmptyCartView.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 7.12.2023.
//

import UIKit

protocol EmptyCartViewDelegate: AnyObject {
    func exploreFoodsButtonPressed()
}

class EmptyCartView: UIView {
    
    weak var delegate: EmptyCartViewDelegate?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    @IBAction func exploreFoods_TUI(_ sender: UIButton) {
        print("exploreFoods_TUI")
        delegate?.exploreFoodsButtonPressed()
    }
}
