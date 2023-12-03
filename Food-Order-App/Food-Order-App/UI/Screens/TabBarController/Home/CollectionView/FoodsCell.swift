//
//  CollectionViewCell.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 28.11.2023.
//

import UIKit
import Kingfisher

class FoodsCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupAddButton() // it can writeable on cellForItem instead of here. It doesn't matter.
        addCellCornerRadius()
        
    }
    
    @IBAction func addButton_TUI(_ sender: UIButton) {
        // add to the basket via delegate method.
    }
    
    func addCellCornerRadius() {
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
    
    func setupAddButton() {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 32, weight: .regular, scale: .large)
        let largeBoldDoc = UIImage(systemName: "plus.square.fill", withConfiguration: largeConfig)
        addButton.setImage(largeBoldDoc, for: .normal)
        
        addButton.tintColor = UIColor(hexString: "#1B1212")
    }
    
    func setupCellWithColor(index: Int) {
        let colors: [String] = ["#B9E4F3", "#C3F3D9", "#FFB7C5", "#DAC3FF", "#D9FFF3", "#FFE0B7", "#F7CED7", "#C8B9F3", "#F3B9D9", "#FFEC80"]
        let colorIndex = index % colors.count
        self.backgroundColor = UIColor(hexString: colors[colorIndex])
        }
}
