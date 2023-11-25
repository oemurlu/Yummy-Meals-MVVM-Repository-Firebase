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
    
    private let viewModel: SignUpViewModel
    var isExpand: Bool = false
        
    required init?(coder: NSCoder) {
        print("required")
        self.viewModel = SignUpViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSignUpButton()
        setupScrollView()
    }
    
    @IBAction func signUpButton_TUI(_ sender: UIButton) {
        self.view.endEditing(true)
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

//    @objc func keyboardAppear(notification: NSNotification) {
//        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardHeight = keyboardFrame.cgRectValue.height
//            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
//            scrollView.contentInset = contentInsets
//            scrollView.scrollIndicatorInsets = contentInsets
//        }
//    }
//
//    @objc func keyboardDisappear(notification: NSNotification) {
//        scrollView.contentInset = .zero
//        scrollView.scrollIndicatorInsets = .zero
//    }
    
}
