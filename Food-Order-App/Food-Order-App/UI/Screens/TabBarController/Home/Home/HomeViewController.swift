//
//  HomeViewController.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 8.11.2023.
//

import UIKit

final class HomeViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var welcomingMessageLabel: UILabel!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var filterButton: UIButton!
    
    private var messageLabel: UILabel?
    private let viewModel: HomeViewModel
    
    required init?(coder: NSCoder) {
        let userRepository = UserRepository()
        self.viewModel = HomeViewModel(repo: userRepository)
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupMessageLabel("Today's Offers!")
        setupWelcomingLabel()
        
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
        let desiredWidth = view.layer.bounds.size.width
        let popVC = PopOverSortingViewController()
        popVC.delegate = self
        
        self.presentPopOver(viewController: popVC, sender: filterButton, size: CGSize(width: desiredWidth / 1.7, height: desiredWidth / 1.6), arrowDirection: .right)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeToFoodDetail" {
            if let food = sender as? Foods {
                let destinationVC = segue.destination as! FoodDetailViewController
                destinationVC.viewModel?.food = food
            }
        }
    }
    
    func presentPopOver(viewController: UIViewController, sender: UIView, size: CGSize, arrowDirection: UIPopoverArrowDirection) {
        viewController.preferredContentSize = size
        viewController.modalPresentationStyle = .popover
        
        if let pres = viewController.presentationController {
            pres.delegate = self
        }
        
        present(viewController, animated: true)
        
        if let pop = viewController.popoverPresentationController {
            pop.sourceView = sender
            pop.sourceRect = sender.bounds
            pop.permittedArrowDirections = arrowDirection
        }
    }
    
    private func setupWelcomingLabel() {
        viewModel.getUserName { name in
            self.welcomingMessageLabel.text = "Hi \(name)"
        }
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
        return viewModel.filteredList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let food = viewModel.filteredList[indexPath.row]
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let food = viewModel.filteredList[indexPath.row]
        performSegue(withIdentifier: "homeToFoodDetail", sender: food)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
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
        let food = viewModel.filteredList[indexPath.row]
        viewModel.addFoodToCart(foodName: food.yemek_adi!, foodImageName: food.yemek_resim_adi!, foodPrice: Int(food.yemek_fiyat!)!, foodOrderCount: 1)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchBarTextDidChange(text: searchText)
    }
}

extension HomeViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

extension HomeViewController: PopOverSortingDelegate {
    func filterCellDidSelect(filterBy: FilterBy) {
        DispatchQueue.main.async {
            switch filterBy {
            case .todaysOffers:
                self.viewModel.loadFoodsByFilter(filter: .todaysOffers)
            case .ascending:
                self.viewModel.loadFoodsByFilter(filter: .ascending)
            case .descending:
                self.viewModel.loadFoodsByFilter(filter: .descending)
            case .aToZ:
                self.viewModel.loadFoodsByFilter(filter: .aToZ)
            case .zToA:
                self.viewModel.loadFoodsByFilter(filter: .zToA)
            }
        }
    }
}
