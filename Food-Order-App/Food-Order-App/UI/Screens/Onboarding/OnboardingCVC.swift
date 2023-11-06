//
//  OnboardingCVC.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 4.11.2023.
//

import UIKit

class OnboardingCVC: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    func setup(slide: OnboardingSlide) {
        label.text = slide.label
        imageView.image = slide.image
    }
}
