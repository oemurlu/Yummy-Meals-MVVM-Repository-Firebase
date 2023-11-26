//
//  SignUpViewController.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 10.11.2023.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
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
    }
    
    @IBAction func signUpButton_TUI(_ sender: UIButton) {
        self.view.endEditing(true)
        //        viewModel.checkTextFields(tf1: usernameTextField.text ?? "", tf2: fullNameTextField.text ?? "", tf3: emailTextField.text ?? "", tf4: phoneNumberTextField.text ?? "", tf5: passwordTextField.text ?? "", tf6: passwordConfirmTextField.text ?? "")
        
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
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
    
    func showPasswordError() {
        let alertController = UIAlertController(title: "Error", message: "Passwords do not match.", preferredStyle: .alert)
        let okeyAction = UIAlertAction(title: "Try Again", style: .default)
        alertController.addAction(okeyAction)
        self.present(alertController, animated: true)
    }
    
    func goToSignInScreen() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController {
                self.navigationController?.pushViewController(signInVC, animated: true)
            }
        }
    }
}
