//
//  EntranceViewController.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 9.11.2023.
//

import UIKit

class EntranceViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtons()
    }
    
    @IBAction func signInButton_TUI(_ sender: UIButton) {
        performSegue(withIdentifier: "toSignIn", sender: nil)
    }
    @IBAction func signUpButton_TUI(_ sender: UIButton) {
        performSegue(withIdentifier: "toSignUp", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSignIn" {
            if let signUpVC = segue.destination as? SignUpViewController {
                let userRepository = UserRepository()
                signUpVC.viewModel = SignUpViewModel(userRepo: userRepository)
            }
        } else if segue.identifier == "toSignUp" {
            print("up")
        }
    }
    
    func setupButtons() {
        //signInButton
        signInButton.backgroundColor = UIColor(named: "red")
        signInButton.tintColor = UIColor(named: "white")
        signInButton.layer.cornerRadius = 10
        
        //signUpButton
        signUpButton.tintColor = UIColor(named: "gray")
        signUpButton.layer.borderWidth = 1.0
        signUpButton.layer.borderColor = UIColor(named: "red")?.cgColor
        signUpButton.layer.cornerRadius = 10
    }
}
