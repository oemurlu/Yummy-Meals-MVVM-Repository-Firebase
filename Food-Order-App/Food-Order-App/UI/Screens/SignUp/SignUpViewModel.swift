//
//  SignUpViewModel.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 25.11.2023.
//

import Foundation
import UIKit.UIStoryboard

protocol SignUpProtocol: AnyObject {
    func showAlertMessage(title: String, message: String, style: UIAlertController.Style)
    func showPasswordError()
    func goToSignInScreen()
}

class SignUpViewModel {
    
    var username: String?
    var fullName: String?
    var email: String?
    var phoneNumber: String?
    var password: String?
    var confirmPassword: String?
    
    weak var delegate: SignUpProtocol?
    var userRepo: UserRepository
    
    init(userRepo: UserRepository) {
        self.userRepo = userRepo
    }
    
    
    func checkTextFields() {
        print("checkTextFields...")
        let textFields = [username, fullName, email, phoneNumber, password, confirmPassword]
        // check the all text fields whether is empty or not
        let allTextFieldsFilled = textFields.allSatisfy { $0!.isEmpty == false }
        
        if allTextFieldsFilled {
            checkPasswords(pw1: password!, pw2: confirmPassword!)
        } else {
            delegate?.showAlertMessage(title: "Error", message: "Please fill all the fields.", style: .alert)
        }
    }
    
    func checkPasswords(pw1: String, pw2: String) {
        if pw1 == pw2 {
            createUser(username: username!, fullName: fullName!, email: email!, phoneNumber: phoneNumber!, pw: password!)
        } else {
            delegate?.showPasswordError()
        }
    }
    
    func createUser(username: String, fullName: String, email: String, phoneNumber: String, pw: String) {
        userRepo.createUser(email: email, pw: pw) { [weak self] result in
            switch result {
            case .success(_):
                self?.saveUserInfosToFirestore(username: username, fullName: fullName, email: email, phoneNumber: phoneNumber)
            case .failure(let error):
                self?.delegate?.showAlertMessage(title: "Error", message: error.localizedDescription, style: .alert)
            }
        }
    }
    
    func saveUserInfosToFirestore(username: String, fullName: String, email: String, phoneNumber: String) {
        userRepo.saveUserInfosToFirestore(username: username, fullName: fullName, email: email, phoneNumber: phoneNumber) { result in
            switch result {
            case .success():
                self.delegate?.goToSignInScreen()
            case .failure(let error):
                self.delegate?.showAlertMessage(title: "Error", message: error.localizedDescription, style: .alert)
            }
        }
    }
}
