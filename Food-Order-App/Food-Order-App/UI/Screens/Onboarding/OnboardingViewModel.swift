//
//  OnboardingViewModel.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 4.11.2023.
//

import UIKit

protocol OnboardingViewModelProtocol: AnyObject {
    func scrollCollectionView(at: IndexPath, position: UICollectionView.ScrollPosition, animated: Bool)
    func currentPageChanged(currentPage: Int, title: String, fontSize: CGFloat, fontName: String)
    func showNavigationController()
}

class OnboardingViewModel {
    
    var slides = [OnboardingSlide]()
    var currentPage = 0 {
        didSet {
            if currentPage == slides.count - 1 {
                delegate?.currentPageChanged(currentPage: currentPage, title: "Get Started", fontSize: 32.0, fontName: "Helvetica")
            } else {
                delegate?.currentPageChanged(currentPage: currentPage, title: "Next", fontSize: 40.0, fontName: "Helvetica")
            }
        }
    }

    weak var delegate: OnboardingViewModelProtocol?
    
    init() {
        createSlides()
    }
    
    func nextButton_TUI() {
        if currentPage == slides.count - 1 {
            delegate?.showNavigationController()
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            delegate?.scrollCollectionView(at: indexPath, position: .centeredHorizontally, animated: true)
        }
    }
    
    func createSlides() {
        slides = [
            OnboardingSlide(label: "Delicious Dishes", image: UIImage(named: "burger"), text: "Discover a culinary adventure where each dish is a masterpiece. welcome to the world of Delicious Dishes!"),
            OnboardingSlide(label: "Best Quality Standarts", image: UIImage(named: "quality"), text: "Excellence is our tradition. From field to fork, we promise the Best Quality Standards for an unmatched dining experience."),
            OnboardingSlide(label: "Fast Delivery", image: UIImage(named: "delivery-man"), text: "Craving something delicious? We've got you covered. Enjoy swift and reliable Fast Delivery, bringing your favorites to your doorstep in no time."),
        ]
    }
}
