//
//  PaymentViewController.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 20.12.2023.
//

import UIKit

class PaymentViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cardNoLabel: UILabel!
    @IBOutlet weak var validThruMonthLabel: UILabel!
    @IBOutlet weak var validThruYearLabel: UILabel!
    @IBOutlet weak var confirmCardButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConfirmButton()
    }
    
    func setupConfirmButton() {
        confirmCardButton.setTitle("CONFIRM CARD", for: .normal)
        confirmCardButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 28)
        confirmCardButton.layer.cornerRadius = 12.0
        confirmCardButton.backgroundColor = .black
        confirmCardButton.tintColor = UIColor(named: "white")
    }
    
    @IBAction func textFieldsChanged(_ sender: UITextField) {
        switch sender.tag {
        case 0:
            nameLabel.text = sender.text
        case 1:
            cardNoLabel.text = sender.text
        case 2:
            validThruMonthLabel.text = sender.text
        case 3:
            validThruYearLabel.text = sender.text
        default:
            break
        }
    }
    
    @IBAction func confirmCardButton_TUI(_ sender: UIButton) {
        MakeAlert.alertMessageWithHandler(title: "Success", message: "Your payment has been confirmed, your order will arrive soon :)", style: .alert, vc: self) {
            DispatchQueue.main.async {
                if let tabBarVC = self.tabBarController, let viewControllers = tabBarVC.viewControllers, viewControllers.indices.contains(0) {
                    tabBarVC.selectedViewController = viewControllers[0]
                }
            }
        }
    
    }
    
}
