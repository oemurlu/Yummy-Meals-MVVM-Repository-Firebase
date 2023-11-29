//
//  CustomFlowLayout.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 28.11.2023.
//

import Foundation
import UIKit

class CustomFlowLayout: UICollectionViewFlowLayout {
    // Özel başlık için yükseklik belirleme
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }

    // Hücrenin boyutunu belirleme
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Sütun sayısına göre hücre boyutunu hesapla
        let numberOfColumns: CGFloat = 2
        let itemWidth = (collectionView.frame.width - (numberOfColumns - 1) * minimumInteritemSpacing) / numberOfColumns
        return CGSize(width: itemWidth, height: itemWidth)
    }

    // Hücre arasındaki boşluğu belirleme
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    // Satırlar arasındaki boşluğu belirleme
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
