//
//  FoodDetailViewController.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 7.12.2023.
//

import UIKit

class FoodDetailViewController: UIViewController {

    @IBOutlet weak var imageViewFood: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var decreaseQuantityButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var increaseQuantityButton: UIButton!
    @IBOutlet weak var foodPriceLabel: UILabel!
    @IBOutlet weak var addFoodToCartButton: UIButton!
    @IBOutlet weak var freeDeliveryLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupQuantityButtonsAndLabel()
        setupAddFootToCartButton()
        setupStackViewLabels()
    }
    
    @IBAction func addFoodToCartButton_TUI(_ sender: UIButton) {
    }
    
    func setupStackViewLabels() {
        freeDeliveryLabel.layer.cornerRadius = 10
        freeDeliveryLabel.layer.masksToBounds = true
        freeDeliveryLabel.layer.borderWidth = 1
        
        minuteLabel.layer.cornerRadius = 10
        minuteLabel.layer.masksToBounds = true
        minuteLabel.layer.borderWidth = 1
        
        ratingLabel.layer.cornerRadius = 10
        ratingLabel.layer.masksToBounds = true
        ratingLabel.layer.borderWidth = 1
    }
    
    func setupQuantityButtonsAndLabel() {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 32, weight: .regular, scale: .large)
        let largeBoldMinus = UIImage(systemName: "minus.square.fill", withConfiguration: largeConfig)
        let largeBoldPlus = UIImage(systemName: "plus.square.fill", withConfiguration: largeConfig)
        
        decreaseQuantityButton.setImage(largeBoldMinus, for: .normal)
        increaseQuantityButton.setImage(largeBoldPlus, for: .normal)
        
        let color = UIColor(hexString: "#1B1212")
        
        decreaseQuantityButton.tintColor = color
        increaseQuantityButton.tintColor = color
        
        quantityLabel.tintColor = color
        quantityLabel.font = UIFont(name: "HelveticaNeue", size: 32)
    }
    
    func setupAddFootToCartButton() {
        addFoodToCartButton.setTitle("Add to Cart", for: .normal)
        addFoodToCartButton.titleLabel?.font = UIFont(name: "Helvetica", size: 30)
        addFoodToCartButton.titleLabel?.adjustsFontSizeToFitWidth = true  //Metni sığdırmak için ekledik
        addFoodToCartButton.backgroundColor = UIColor(named: "red")
        addFoodToCartButton.tintColor = UIColor(named: "white")
        addFoodToCartButton.layer.cornerRadius = 10
    }
    
    
}
