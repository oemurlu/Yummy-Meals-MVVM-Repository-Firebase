//
//  FavoritesViewController.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 10.12.2023.
//

import UIKit
import Kingfisher

class FavoritesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: FavoritesViewModel
    
    required init?(coder: NSCoder) {
        self.viewModel = FavoritesViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = (screenWidth - 30) / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.18)
        collectionView.collectionViewLayout = layout
    }
}

extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return viewModel.favoriteFoods.count
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let food = viewModel.favoriteFoods[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoritesCell", for: indexPath) as! FavoritesCell
//        
//        cell.indexPath = indexPath
//        
//        if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(food.yemek_resim_adi!)") {
//            DispatchQueue.main.async {
//                cell.imageFood.kf.setImage(with: url)
//            }
//        }
//        
//        cell.delegate = self
        return cell
    }
}

extension FavoritesViewController: FavoritesCellProtocol {
    
}

extension FavoritesViewController: FavoritesViewModelProtocol {
    func foodsDidLoad() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            print("fcv reloaded")
        }
    }
}

