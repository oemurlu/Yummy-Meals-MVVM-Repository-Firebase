//
//  ProfileViewController.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 18.12.2023.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    let viewModel: ProfileViewModel
    
    required init?(coder: NSCoder) {
        let repo = UserRepository()
        self.viewModel = ProfileViewModel(repo: repo)
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBarTitle()
        viewModel.delegate = self
        viewModel.fetchInfosFromFirestore()
    }
    
    @IBAction func logoutBarButtonItem_TUI(_ sender: UIBarButtonItem) {
        signOutAlert()
    }
    
    @IBAction func uploadPhotoButton_TUI(_ sender: UIButton) {
    }
    
    
    func signOutAlert() {
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to logout ?", preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { _ in
            self.viewModel.logout()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    func setupNavBarTitle() {
        navigationItem.title = "Profile"
        navigationController?.navigationBar.largeTitleTextAttributes = [.font: UIFont.systemFont(ofSize: 40, weight: .bold), .foregroundColor: UIColor.black]
        navigationItem.largeTitleDisplayMode = .always
    }

}

extension ProfileViewController: ProfileViewModelDelegate {
    func infosDidLoad(username: String, fullName: String, email: String, phoneNumber: String) {
        DispatchQueue.main.async {
            self.usernameLabel.text = username
            self.fullNameLabel.text = fullName
            self.emailLabel.text = email
            self.phoneLabel.text = phoneNumber
        }
    }
    
    func logoutSuccess() {
        DispatchQueue.main.async {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "navigationController") as? UINavigationController
            vc?.modalPresentationStyle = .fullScreen
            vc?.modalTransitionStyle  = .partialCurl
            self.present(vc!, animated: true)
        }
    }
    
    func logoutFailure(errorMessage: String) {
        MakeAlert.alertMessage(title: "Error", message: errorMessage, style: .alert, vc: self)
    }
}
