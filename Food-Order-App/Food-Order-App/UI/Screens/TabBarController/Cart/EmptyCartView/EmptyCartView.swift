//
//  EmptyCartView.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 7.12.2023.
//

import UIKit

class EmptyCartView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    @IBAction func exploreFoods_TUI(_ sender: UIButton) {
        // Show home screen with animation
        if let tabBarController = self.window?.rootViewController as? UITabBarController {
            tabBarController.selectedIndex = 0
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = .fade
            tabBarController.view.layer.add(transition, forKey: kCATransition)
        }
    }
}
