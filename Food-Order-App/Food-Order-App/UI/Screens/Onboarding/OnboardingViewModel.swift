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
            // TODO: performSegue to home screen
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            delegate?.scrollCollectionView(at: indexPath, position: .centeredHorizontally, animated: true)
        }
    }
    
    func createSlides() {
        print("slaytlar olusturuluyor....")
        slides = [
            OnboardingSlide(label: "Delicious Dishes", image: UIImage(systemName: "square.and.arrow.up.fill")),
            OnboardingSlide(label: "Best Quality Standarts", image: UIImage(systemName: "rectangle.portrait.and.arrow.forward.fill")),
            OnboardingSlide(label: "Fast Delivery", image: UIImage(systemName: "eraser.line.dashed.fill")),
        ]
    }
}
