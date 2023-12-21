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
    @IBOutlet weak var emptyCartView: EmptyCartView!
    
    
    private let viewModel: CartViewModel
    
    required init?(coder: NSCoder) {
        let userRepository = UserRepository()
        self.viewModel = CartViewModel(repo: userRepository)
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
        
        emptyCartView.isHidden = true
        totalCartPriceLabel.isHidden = true
        confirmCartButton.isHidden = true
        tableView.isHidden = true
        viewModel.totalCartPrice = 0
        
        viewModel.loadFoods()
    }
    
    func setupConfirmCartButton() {
        confirmCartButton.setTitle("CHECKOUT", for: .normal)
        confirmCartButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 28)
        confirmCartButton.layer.cornerRadius = 12.0
        confirmCartButton.backgroundColor = .black
        confirmCartButton.tintColor = UIColor(named: "white")
    }
    
    func setupTotalCartPriceLabel() {
        totalCartPriceLabel.text = "$ 0"
        totalCartPriceLabel.font = UIFont(name: "Helvetica-Bold", size: 28)
        totalCartPriceLabel.tintColor = UIColor.black
    }
    
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func confirmCartButton_TUI(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "cartToPayment", sender: nil)
        }
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
        
        //total food price
        if let quantity = food.yemek_siparis_adet?.toInt(), let price = food.yemek_fiyat?.toInt() {
            let totalPrice = quantity * price
            cell.foodPriceLabel.text = "$ \(totalPrice)"
        }
        
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
            self.viewModel.totalCartPrice = 0
            self.viewModel.loadFoods()
        }
    }
    
    func isCartEmpty(isEmpty: Bool) {
        emptyCartView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
        confirmCartButton.isHidden = isEmpty
        totalCartPriceLabel.isHidden = isEmpty
    }
    
    func totalCartPriceChanged(price: Int) {
        DispatchQueue.main.async {
            print("fiyat hesaplandi...")
            self.totalCartPriceLabel.text = "$ \(price)"
        }
    }
}

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
        
        // update totalCartPriceLabel
        viewModel.totalCartPrice = 0
    }
    
    func updateTotalCartPrice() {
        self.totalCartPriceLabel.text = "$ \(viewModel.totalCartPrice)"
    }
}
