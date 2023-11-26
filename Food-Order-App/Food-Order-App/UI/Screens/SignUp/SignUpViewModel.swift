//
//  SignUpViewModel.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 25.11.2023.
//

import Foundation

protocol SignUpProtocol: AnyObject {
    func showErrorMsg()
    func showPasswordError()
}

class SignUpViewModel {
    
    weak var delegate: SignUpProtocol?
        
    func checkTextFields(tf1: String, tf2: String, tf3: String, tf4: String, tf5: String, tf6: String) {
        let textFields = [tf1, tf2, tf3, tf4, tf5, tf6]
        
        // check the all text fields whether is empty or not
        let allTextFieldsFilled = textFields.allSatisfy { $0.isEmpty == false }
        
        if allTextFieldsFilled {
            checkPasswords(pw1: tf5, pw2: tf6)
        } else {
            delegate?.showErrorMsg()
        }
    }
    
    func checkPasswords(pw1: String, pw2: String) {
        if pw1 == pw2 {
            signUpClicked()
        } else {
            delegate?.showPasswordError()
        }
    }
    
    func signUpClicked() {
        //TODO: bind to repostory
        //completion handlerda sign in ekranina git diyecez.
    }
}
