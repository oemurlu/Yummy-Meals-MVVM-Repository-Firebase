//
//  PaymentViewModel.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 26.12.2023.
//

import Foundation
import UIKit

protocol PaymentViewModelDelegate: AnyObject {
    func paymentSuccess()
    func showAlertMessage(title: String, message: String, style: UIAlertController.Style)
}

class PaymentViewModel {
    var fullName: String?
    var cardNo: String?
    var validMonth: String?
    var validYear: String?
    var cvc: String?
    
    weak var delegate: PaymentViewModelDelegate?
    
    func checkTextFields() {
        let textFields = [fullName, cardNo, validMonth, validYear, cvc]
        // check the all text fields whether is empty or not
        let allTextFieldsFilled = textFields.allSatisfy { $0!.isEmpty == false }
        
        if allTextFieldsFilled {
            print("success")
            self.delegate?.paymentSuccess()
        } else {
            print("problem")
            self.delegate?.showAlertMessage(title: "Error", message: "Please fill all the fields.", style: .alert)
        }
    }
}

