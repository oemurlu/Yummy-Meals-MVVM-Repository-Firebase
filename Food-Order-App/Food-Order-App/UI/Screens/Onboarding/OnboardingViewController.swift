//
//  OnboardingViewController.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 4.11.2023.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let viewModel = OnboardingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        setupNextButton()
    }
    
    func setupNextButton() {
        nextButton.setTitle("Next", for: .normal)
        nextButton.titleLabel?.font = UIFont(name: "Helvetica", size: 40)
        nextButton.layer.cornerRadius = 12.0
    }
    
    @IBAction func nextButton_TUI(_ sender: UIButton) {
        viewModel.nextButton_TUI()
    }
}

extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCVC", for: indexPath) as! OnboardingCVC
        cell.setup(slide: viewModel.slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    // ScrollView kaydirmasi tamamlaninca cagirilir.
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        viewModel.currentPage = Int(scrollView.contentOffset.x / pageWidth)
        // scrollView'in total genisligi ekran genisligine bolunurse index'i verir. Bu sayede pageControl'u takip ederiz.
    }
}

extension OnboardingViewController: OnboardingViewModelProtocol {
    
    func currentPageChanged(currentPage: Int, title: String, fontSize: CGFloat, fontName: String) {
        pageControl.currentPage = currentPage
        nextButton.setTitle(title, for: .normal)
        nextButton.titleLabel?.font = UIFont(name: fontName, size: fontSize)
    }
    
    func scrollCollectionView(at: IndexPath, position: UICollectionView.ScrollPosition, animated: Bool) {
        collectionView.scrollToItem(at: at, at: position, animated: animated)
    }
    
    func showTabBarController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarController = storyboard.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController {
            let currentViewController = self.view.window?.rootViewController
            let newViewController = tabBarController
            
            if let currentView = currentViewController?.view, let newView = newViewController.view {
                UIView.transition(from: currentView, to: newView, duration: 0.5, options: .transitionCrossDissolve) { _ in
                    self.view.window?.rootViewController = newViewController
                }
            }
        }
    }
}


