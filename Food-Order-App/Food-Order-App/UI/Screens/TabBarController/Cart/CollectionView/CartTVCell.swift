//
//  CartTVCell.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 5.12.2023.
//

import UIKit

protocol CartTVCellProtocol: AnyObject {
    func decreaseQuantity(indexPath: IndexPath)
    func increaseQuantity(indexPath: IndexPath)
}

final class CartTVCell: UITableViewCell {
    
    @IBOutlet weak var imageFood: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var minusQuantityButton: UIButton!
    @IBOutlet weak var plusQuantityButton: UIButton!
    @IBOutlet weak var foodPriceLabel: UILabel!
    
    weak var delegate: CartTVCellProtocol?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addCellCornerRadius()
        setupQuantityButtonsAndLabel()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func minusButton_TUI(_ sender: UIButton) {
        delegate?.decreaseQuantity(indexPath: indexPath!)
    }
    @IBAction func plusButton_TUI(_ sender: UIButton) {
        delegate?.increaseQuantity(indexPath: indexPath!)
    }
    
    func setupQuantityButtonsAndLabel() {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .large)
        let largeBoldMinus = UIImage(systemName: "minus.square.fill", withConfiguration: largeConfig)
        let largeBoldPlus = UIImage(systemName: "plus.square.fill", withConfiguration: largeConfig)
        
        minusQuantityButton.setImage(largeBoldMinus, for: .normal)
        plusQuantityButton.setImage(largeBoldPlus, for: .normal)
        
        let color = UIColor(hexString: "#1B1212")
        
        minusQuantityButton.tintColor = color
        plusQuantityButton.tintColor = color
        
        quantityLabel.tintColor = color
        quantityLabel.font = UIFont(name: "HelveticaNeue", size: 24)
    }
    
    
    func addCellCornerRadius() {
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
    
    func setupCellColor(index: Int) {
        let colors: [String] = ["#B9E4F3", "#C3F3D9", "#FFB7C5", "#DAC3FF", "#D9FFF3", "#FFE0B7", "#F7CED7", "#C8B9F3", "#F3B9D9", "#FFEC80"]
        let colorIndex = index % colors.count
        self.backgroundColor = UIColor(hexString: colors[colorIndex])
    }
}
