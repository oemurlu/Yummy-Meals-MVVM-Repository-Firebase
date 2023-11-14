//
//  SignInViewController.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 10.11.2023.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTexfField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    private let viewModel: SignInViewModel
    
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = SignInViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSignInButton()
        
    }
    
    func setupSignInButton() {
        signInButton.titleLabel?.font = UIFont(name: "Helvetica", size: 40)
        signInButton.backgroundColor = UIColor(named: "red")
        signInButton.tintColor = UIColor(named: "white")
        signInButton.layer.cornerRadius = 10
    }
    
    @IBAction func signInButton_TUI(_ sender: UIButton) {
        if let email = emailTexfField.text, let password = passwordTextField.text {
            viewModel.signInClicked(email: email, pw: password)
        }
    }
}
