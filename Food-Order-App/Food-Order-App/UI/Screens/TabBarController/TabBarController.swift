//
//  TabBarController.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 8.11.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isTranslucent = true
        tabBar.backgroundColor = .white
        
        ActivityIndicatorHelper.shared.stop()
    }
}
