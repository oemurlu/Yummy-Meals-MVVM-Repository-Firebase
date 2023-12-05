//
//  CartViewController.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 3.12.2023.
//

import UIKit
import Kingfisher

class CartViewController: UIViewController {
    
    //    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var confirmCartButton: UIButton!
    @IBOutlet weak var totalCartPriceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
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
        setupTableView()
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
    
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func confirmCartButton_TUI(_ sender: UIButton) {
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.cartFoods.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let food = viewModel.cartFoods[indexPath.section]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCellTV", for: indexPath) as! CartTVCell
        
        cell.setupCellColor(index: indexPath.section)
        cell.nameLabel.text = food.yemek_adi
        cell.priceLabel.text = "$ \(food.yemek_fiyat!)"
        
        if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(food.yemek_resim_adi!)") {
            DispatchQueue.main.async {
                cell.imageFood.kf.setImage(with: url)
            }
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let food = viewModel.cartFoods[indexPath.row]
        let yemekId = food.sepet_yemek_id!
        viewModel.deleteItemFromCart(foodOrderId: yemekId)
    }
    
    // disable click cell behavior
    //    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    //        return nil
    //    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 144
    }
}


extension CartViewController: CartViewModelProtocol {
    func foodsDidLoad() {
        DispatchQueue.main.async {
            //            self.collectionView.reloadData()
            self.tableView.reloadData()
        }
    }
    
    func foodDeleted() {
        DispatchQueue.main.async {
            self.viewModel.loadFoods()
        }
    }
}

extension CartViewController: CartTVCellProtocol {
    
    func decreaseQuantity(indexPath: IndexPath) {
        //        let food = viewModel.cartFoods[indexPath.row]
        //TODO: decrease the quantity
    }
    func increaseQuantity(indexPath: IndexPath) {
        //TODO: increase the quantity
    }
}
