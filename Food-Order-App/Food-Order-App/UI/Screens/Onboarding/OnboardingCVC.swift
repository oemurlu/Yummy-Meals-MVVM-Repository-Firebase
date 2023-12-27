//
//  OnboardingCVC.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 4.11.2023.
//

import UIKit

class OnboardingCVC: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    
    func setup(slide: OnboardingSlide) {
        label.text = slide.label
        imageView.image = slide.image
        textLabel.text = slide.text
    }
}
