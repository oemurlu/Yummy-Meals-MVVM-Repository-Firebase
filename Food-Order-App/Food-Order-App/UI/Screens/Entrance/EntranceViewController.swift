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

        
        print("asdasdsjn")
        setupButtons()
        

    }
    
    @IBAction func signInButton_TUI(_ sender: UIButton) {
        print("inbutton")
        performSegue(withIdentifier: "toSignIn", sender: nil)
    }
    @IBAction func signUpButton_TUI(_ sender: UIButton) {
        print("upbutton")
        performSegue(withIdentifier: "toSignUp", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare calisti")
        if segue.identifier == "entranceToSignIn" {
            print("in")
        } else if segue.identifier == "entranceToSignUp" {
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
