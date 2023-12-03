//
//  HomeViewController.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 8.11.2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var welcomingMessageLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var messageLabel: UILabel?
    private let viewModel: HomeViewModel
    
    required init?(coder: NSCoder) {
        self.viewModel = HomeViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupMessageLabel("Today's Offers!")
        
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func filterButtonPressed(_ sender: UIButton) {
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.collectionViewLayout = .createCompositionalLayout()
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
    }
    
    private func setupMessageLabel(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 16, y: 12, width: self.collectionView.bounds.size.width - 32, height: 40))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 1
        messageLabel.textAlignment = .left
        messageLabel.font = UIFont(name: "Helvetica", size: 24)
        self.collectionView.addSubview(messageLabel)
        self.messageLabel = messageLabel
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.foodsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let food = viewModel.foodsList[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodsCell", for: indexPath) as! FoodsCell
        
        cell.setupCellColor(index: indexPath.row)
        
        cell.nameLabel.text = food.yemek_adi
        cell.priceLabel.text = "$ \(food.yemek_fiyat ?? "0")"
        
        if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(food.yemek_resim_adi!)") {
            DispatchQueue.main.async {
                cell.image.kf.setImage(with: url)
            }
        }
        
        cell.delegate = self
        cell.indexPath = indexPath
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // FIX IT !!!! -> I added comment line to the code and the problem is solved.
        // Probably the problem is: if the cell is empty, xcode get confused xd
        // some cell's was disappearing while scrolling. this is a temporary solution
//        DispatchQueue.main.async {
//            self.collectionView.reloadData()
//        }
        
        // Determine the y-axis movement limit for the messageLabel
        let upperLimit: CGFloat = 12
        let lowerLimit: CGFloat = 72
        
        // Adjust messageLabel's y position based on scrollView's contentOffset.y
        let offsetY = scrollView.contentOffset.y
        var newLabelY = lowerLimit - offsetY
        newLabelY = min(upperLimit, newLabelY)
        newLabelY = max(-40, newLabelY) // Hide label when it's completely out of view
        
        messageLabel?.frame.origin.y = newLabelY
        
        // Hide and unhide Today's Offers label
        if offsetY > 160 {
            messageLabel?.isHidden = true
        } else {
            messageLabel?.isHidden = false
        }
    }
}

extension HomeViewController: HomeViewModelProtocol {
    func foodsDidLoad() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension HomeViewController: FoodsCellProtocol {
    func addFoodToBasket(indexPath: IndexPath) {
        let food = viewModel.foodsList[indexPath.row]
        print("\(food.yemek_adi!) sepete eklendi")
        //TODO: make network request for adding food to the basket
        // we need username; => we need to get username from firebase
        viewModel.addFoodToCart(foodName: food.yemek_adi!, foodImageName: food.yemek_resim_adi!, foodPrice: Int(food.yemek_fiyat!)!, foodOrderCount: 1)
    }
}
