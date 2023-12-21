//
//  FoodDetailViewController.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 7.12.2023.
//

import UIKit
import Kingfisher

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
    
    let viewModel: FoodVDetailviewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupQuantityButtonsAndLabel()
        setupAddFootToCartButton()
        setupStackViewLabels()
        configureFood()
        
        viewModel?.delegate = self
    }
    
    required init?(coder: NSCoder) {
        let userRepository = UserRepository()
        self.viewModel = FoodVDetailviewModel(repo: userRepository)
        super.init(coder: coder)
    }
    
    @IBAction func decreaseQuantityButton_TUI(_ sender: UIButton) {
        viewModel?.decreaseQuantity()
    }
    
    @IBAction func increaseQuantityButton_TUI(_ sender: UIButton) {
        viewModel?.increaseQuantity()
    }
    
    @IBAction func addFoodToCartButton_TUI(_ sender: UIButton) {
        viewModel?.addToCart()
    }
    
    func configureFood() {
        if let viewModel = viewModel,
           let food = viewModel.food {
            foodNameLabel.text = food.yemek_adi
            foodPriceLabel.text = "$ \(food.yemek_fiyat!)"
            quantityLabel.text = "\(viewModel.quantityOfOrder!)"
        }
        
        let randomRating = viewModel?.randomBetween3_5And5_0()
        ratingLabel.text = "\(randomRating ?? "4.2") Rating"
        
        if let viewModel = viewModel,
           let food = viewModel.food,
           let yemekResimAdi = food.yemek_resim_adi,
           let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(yemekResimAdi)") {
            DispatchQueue.main.async {
                self.imageViewFood.kf.setImage(with: url)
            }
        }
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

extension FoodDetailViewController: FoodDetailViewModelProtocol {
    func quantityChanged(quantity: Int) {
        quantityLabel.text = "\(quantity)"
    }
    
    func foodPriceChanged(price: Int) {
        foodPriceLabel.text = "$ \(price)"
    }
    
    func addFoodToCart() {
        MakeAlert.alertMessageWithHandler(title: "Success", message: "Food added to cart!", style: .alert, vc: self) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
