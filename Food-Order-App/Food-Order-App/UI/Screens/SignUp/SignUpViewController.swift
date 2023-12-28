//
//  SignUpViewController.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 10.11.2023.
//

import UIKit

final class SignUpViewController: UIViewController {
    
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var fullNameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var phoneNumberTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordConfirmTextField: UITextField!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    var viewModel: SignUpViewModel
    var isExpand: Bool = false
    
    required init?(coder: NSCoder) {
        let userRepository = UserRepository()
        self.viewModel = SignUpViewModel(userRepo: userRepository)
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        setupSignUpButton()
        setupScrollView()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func signUpButton_TUI(_ sender: UIButton) {
        self.view.endEditing(true)
        ActivityIndicatorHelper.shared.start()
        
        viewModel.username = usernameTextField.text
        viewModel.fullName = fullNameTextField.text
        viewModel.email = emailTextField.text
        viewModel.phoneNumber = phoneNumberTextField.text
        viewModel.password = passwordTextField.text
        viewModel.confirmPassword = passwordConfirmTextField.text
        
        viewModel.checkTextFields()
        
    }
    
    func setupSignUpButton() {
        signUpButton.titleLabel?.font = UIFont(name: "Helvetica", size: 40)
        signUpButton.backgroundColor = UIColor(named: "red")
        signUpButton.tintColor = UIColor(named: "white")
        signUpButton.layer.cornerRadius = 10
    }
    
    func setupScrollView() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardAppear() {
        if !isExpand {
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 100)
            self.isExpand = true
        }
    }
    
    @objc func keyboardDisappear() {
        if isExpand {
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height - 100)
            self.isExpand = false
        }
    }
}

extension SignUpViewController: SignUpProtocol {
    func showAlertMessage(title: String, message: String, style: UIAlertController.Style) {
        ActivityIndicatorHelper.shared.stop()
        MakeAlert.alertMessage(title: title, message: message, style: .alert, vc: self)
    }
    
    func showPasswordError() {
        ActivityIndicatorHelper.shared.stop()
        MakeAlert.alertMessage(title: "Error", message: "Passwords do not match.", style: .alert, vc: self)
    }
    
    func goToSignInScreen() {
        DispatchQueue.main.async {
            ActivityIndicatorHelper.shared.stop()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController {
                self.navigationController?.pushViewController(signInVC, animated: true)
            }
        }
    }
}
