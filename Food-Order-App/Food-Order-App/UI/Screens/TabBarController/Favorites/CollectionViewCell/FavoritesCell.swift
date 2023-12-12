//
//  FavoritesCell.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 10.12.2023.
//

import UIKit

protocol FavoritesCellProtocol: AnyObject {
    
}

class FavoritesCell: UICollectionViewCell {
    
    @IBOutlet weak var imageFood: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    weak var delegate: FavoritesCellProtocol?
    var indexPath: IndexPath?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCell()
        setupFavoriteButton()
    }
    
    @IBAction func favoriteButton_TUI(_ sender: UIButton) {
    }
    
    func setupFavoriteButton() {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 28, weight: .regular, scale: .large)
        let largeBoldDoc = UIImage(systemName: "heart.fill", withConfiguration: largeConfig)
        favoriteButton.setImage(largeBoldDoc, for: .normal)
        favoriteButton.tintColor = .red
    }
    
    func setupCell() {
        layer.borderWidth = 1
        layer.cornerRadius = 12
    }
    
    
}
