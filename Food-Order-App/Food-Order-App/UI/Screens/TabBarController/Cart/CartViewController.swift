//
//  CartViewController.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 3.12.2023.
//

import UIKit
import Kingfisher

class CartViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var confirmCartButton: UIButton!
    @IBOutlet weak var totalCartPriceLabel: UILabel!
    
    private let viewModel: CartViewModel
    
    required init?(coder: NSCoder) {
        self.viewModel = CartViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        setupConfirmCartButton()
        setupTotalCartPriceLabel()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        viewModel.loadFoods()
    }
    
    func setupConfirmCartButton() {
        confirmCartButton.setTitle("CHECKOUT", for: .normal)
        confirmCartButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 28)
        confirmCartButton.layer.cornerRadius = 12.0
        confirmCartButton.backgroundColor = UIColor(named: "red")
        confirmCartButton.tintColor = UIColor(named: "white")
    }
    
    func setupTotalCartPriceLabel() {
        totalCartPriceLabel.font = UIFont(name: "Helvetica-Bold", size: 28)
        totalCartPriceLabel.tintColor = UIColor.black
    }
    
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.minimumLineSpacing = 8
        layout.minimumLineSpacing = 8
        
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = (screenWidth - 16)
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth / 2.8)
        collectionView.collectionViewLayout = layout
        }


    @IBAction func confirmCartButton_TUI(_ sender: UIButton) {
    }
}

extension CartViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cartFoods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let foods = viewModel.cartFoods[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CartCell", for: indexPath) as! CartCell
        
        cell.setupCellColor(index: indexPath.row)
        
        cell.nameLabel.text = foods.yemek_adi
        cell.priceLabel.text = "$ \(foods.yemek_fiyat!)"
        if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(foods.yemek_resim_adi!)") {
            DispatchQueue.main.async {
                cell.image.kf.setImage(with: url)
            }
        }
        return cell
    }
}

extension CartViewController: CartViewModelProtocol {
    func foodsDidLoad() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension CartViewController: CartCellProtocol {
    
    func decreaseQuantity(indexPath: IndexPath) {
//        let food = viewModel.cartFoods[indexPath.row]
        //TODO: decrease the quantity
    }
    func increaseQuantity(indexPath: IndexPath) {
        //TODO: increase the quantity
    }
}
