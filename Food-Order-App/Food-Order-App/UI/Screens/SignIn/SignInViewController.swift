//
//  SignInViewController.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 10.11.2023.
//

import UIKit

final class SignInViewController: UIViewController {
    
    @IBOutlet private weak var emailTexfField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var signInButton: UIButton!
    
    private let viewModel: SignInViewModel
    
    required init?(coder: NSCoder) {
        let userRepository = UserRepository()
        self.viewModel = SignInViewModel(userRepo: userRepository)
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        setupSignInButton()
        
    }
    
    func setupSignInButton() {
        signInButton.titleLabel?.font = UIFont(name: "Helvetica", size: 40)
        signInButton.backgroundColor = UIColor(named: "red")
        signInButton.tintColor = UIColor(named: "white")
        signInButton.layer.cornerRadius = 10
    }
    
    @IBAction func signInButton_TUI(_ sender: UIButton) {
        ActivityIndicatorHelper.shared.start()
        if let email = emailTexfField.text, let password = passwordTextField.text {
            viewModel.signInClicked(email: email, pw: password)
        }
    }
}

extension SignInViewController: SignInProtocol {
    func goToHomeScreen() {
        DispatchQueue.main.async {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController
            vc?.modalPresentationStyle = .fullScreen
            vc?.modalTransitionStyle  = .flipHorizontal
            self.present(vc!, animated: true)
            ActivityIndicatorHelper.shared.start()
        }
    }
    
    func showAlertMessage(title: String, message: String, style: UIAlertController.Style) {
        ActivityIndicatorHelper.shared.stop()
        MakeAlert.alertMessage(title: title, message: message, style: .alert, vc: self)
    }
}
