//
//  PaymentViewController.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 20.12.2023.
//

import UIKit

final class PaymentViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cardNoLabel: UILabel!
    @IBOutlet weak var validThruMonthLabel: UILabel!
    @IBOutlet weak var validThruYearLabel: UILabel!
    @IBOutlet weak var confirmCardButton: UIButton!
    @IBOutlet weak var cvcLabel: UITextField!
    
    let viewModel: PaymentViewModel
    
    required init?(coder: NSCoder) {
        self.viewModel = PaymentViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConfirmButton()
        viewModel.delegate = self
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
        
        viewModel.fullName = self.nameLabel.text
        viewModel.cardNo = self.cardNoLabel.text
        viewModel.validMonth = self.validThruMonthLabel.text
        viewModel.validYear = self.validThruYearLabel.text
        viewModel.cvc = self.cvcLabel.text
        
        viewModel.checkTextFields()
    }
}

extension PaymentViewController: PaymentViewModelDelegate {
    func paymentSuccess() {
        MakeAlert.alertMessageWithHandler(title: "Success", message: "Your payment has been confirmed, your order will arrive soon :)", style: .alert, vc: self) {
            DispatchQueue.main.async {
                if let tabBarVC = self.tabBarController, let viewControllers = tabBarVC.viewControllers, viewControllers.indices.contains(0) {
                    tabBarVC.selectedViewController = viewControllers[0]
                }
            }
        }
    }
    
    func showAlertMessage(title: String, message: String, style: UIAlertController.Style) {
        MakeAlert.alertMessage(title: title, message: message, style: style, vc: self)
    }
}
