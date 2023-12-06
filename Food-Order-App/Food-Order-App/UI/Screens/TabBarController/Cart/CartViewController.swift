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
        cell.delegate = self
        
        cell.setupCellColor(index: indexPath.section)
        cell.nameLabel.text = food.yemek_adi
        cell.priceLabel.text = "$ \(food.yemek_fiyat!)"
        cell.quantityLabel.text = "\(food.yemek_siparis_adet!)"
        
        cell.indexPath = indexPath
        
        if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(food.yemek_resim_adi!)") {
            DispatchQueue.main.async {
                cell.imageFood.kf.setImage(with: url)
            }
        }
        return cell
    }
    
//     disable click cell behavior
        func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
            return nil
        }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let food = viewModel.cartFoods[indexPath.section]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.viewModel.deleteItemFromCart(foodOrderId: food.sepet_yemek_id!)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 144
    }
}


extension CartViewController: CartViewModelProtocol {
    func foodsDidLoad() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func foodDeleted() {
        DispatchQueue.main.async {
            self.viewModel.loadFoods()
        }
    }
}

//extension CartViewController: CartTVCellProtocol {
//    
//    func decreaseQuantity(indexPath: IndexPath) {
//        let food = viewModel.cartFoods[indexPath.section]
//        guard var quantity: Int = Int(food.yemek_siparis_adet!),
//                quantity > 1 else { return }
//        quantity -= 1
//        viewModel.updateQuantity(index: indexPath, newQuantity: quantity)
//    }
//    func increaseQuantity(indexPath: IndexPath) {
//        //TODO: increase the quantity
//        let food = viewModel.cartFoods[indexPath.section]
//        guard var quantity: Int = Int(food.yemek_siparis_adet!), quantity > 0 else { return }
//        quantity += 1
//        viewModel.updateQuantity(index: indexPath, newQuantity: quantity)
//    }
//    
//    func foodQuantityUpdated() {
//        viewModel.loadFoods()
//    }
//}

extension CartViewController: CartTVCellProtocol {
    
    func decreaseQuantity(indexPath: IndexPath) {
        let food = viewModel.cartFoods[indexPath.section]
        guard var quantity = Int(food.yemek_siparis_adet ?? "0"), quantity > 1 else { return }
        quantity -= 1
        viewModel.updateQuantity(index: indexPath, newQuantity: quantity)
    }
    
    func increaseQuantity(indexPath: IndexPath) {
        let food = viewModel.cartFoods[indexPath.section]
        guard var quantity = Int(food.yemek_siparis_adet ?? "0"), quantity > 0 else { return }
        quantity += 1
        viewModel.updateQuantity(index: indexPath, newQuantity: quantity)
    }
    
    func foodQuantityUpdated() {
        viewModel.loadFoods()
    }
}
