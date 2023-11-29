//
//  UICollectionView+Extensions.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 28.11.2023.
//

import UIKit

extension UICollectionViewLayout {
    static func createCompositionalLayout() -> UICollectionViewCompositionalLayout{
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            //Item
            let elementSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            
            let cellHeight = layoutEnvironment.container.effectiveContentSize.height * 0.4 / 2
            
            let leftItem = NSCollectionLayoutItem(layoutSize: elementSize)
            leftItem.contentInsets = NSDirectionalEdgeInsets(top: cellHeight, leading: 0, bottom: -(cellHeight), trailing: 0)

            let rightItem = NSCollectionLayoutItem(layoutSize: elementSize)
//            rightItem.contentInsets = NSDirectionalEdgeInsets(top: cellHeight, leading: 0, bottom: -(cellHeight), trailing: 0)

            
            //Vertical Groups
            let verticalGroupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.48),
                heightDimension: .fractionalHeight(1)
            )
            
            let leftVerticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitems: [leftItem])
            let rightVerticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitems: [rightItem])
            leftVerticalGroup.interItemSpacing = .fixed(10)
            rightVerticalGroup.interItemSpacing = .fixed(10)
            
            //Horizontal Group
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(0.4)
            )
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [leftVerticalGroup, rightVerticalGroup])
            group.interItemSpacing = .flexible(5)
            
            //Section
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            return section
        }
    }
}



