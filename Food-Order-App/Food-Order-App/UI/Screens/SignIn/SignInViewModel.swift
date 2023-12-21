//
//  SignInViewModel.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 14.11.2023.
//

import Foundation
import UIKit.UIAlertController

protocol SignInProtocol: AnyObject {
    func goToHomeScreen()
    func showAlertMessage(title: String, message: String, style: UIAlertController.Style)
}

class SignInViewModel {
    
    weak var delegate: SignInProtocol?
    var userRepo: UserRepository
    
    init(userRepo: UserRepository) {
        self.userRepo = userRepo
    }
    
    func signInClicked(email: String, pw: String) {
        userRepo.signInUser(email: email, pw: pw) { [weak self] result in
            switch result {
            case .success(_):
                self?.delegate?.goToHomeScreen()
            case . failure(_):
                self?.delegate?.showAlertMessage(title: "Error", message: "Invalid e-mail or password.", style: .alert)
            }
        }
    }
}
