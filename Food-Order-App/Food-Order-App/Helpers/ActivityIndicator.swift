//
//  ActivityIndicator.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 21.12.2023.
//

import UIKit

class ActivityIndicatorHelper {
    static let shared = ActivityIndicatorHelper()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .large)
        indicatorView.color = .black
        return indicatorView
    }()
    
    private let keyWindow: UIWindow?
    private var blurView: UIVisualEffectView?
    
    private init() {
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                keyWindow = windowScene.windows.first
            } else {
                keyWindow = nil
            }
        } else {
            keyWindow = UIApplication.shared.keyWindow
        }
    }
    
    func start() {
        setupIndicator()
        activityIndicatorView.startAnimating()
        blurView = addBlurEffect(to: keyWindow)
    }
    
    func stop() {
        activityIndicatorView.stopAnimating()
        removeBlurEffect(blurView)
    }
    
    private func setupIndicator() {
        activityIndicatorView.center = keyWindow?.center ?? CGPoint(x: 0, y: 0)
        keyWindow?.addSubview(activityIndicatorView)
        keyWindow?.bringSubviewToFront(activityIndicatorView)
    }
    
    private func addBlurEffect(to view: UIView?) -> UIVisualEffectView? {
        guard let view = view else { return nil }
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.5
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        return blurEffectView
    }
    
    private func removeBlurEffect(_ blurView: UIVisualEffectView?) {
        blurView?.removeFromSuperview()
    }
}
