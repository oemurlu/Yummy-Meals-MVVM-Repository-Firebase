//
//  ProfileViewController.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 18.12.2023.
//

import UIKit

final class ProfileViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profilePictureImage: UIImageView!
    
    let viewModel: ProfileViewModel
    private let imagePicker = UIImagePickerController()
    
    required init?(coder: NSCoder) {
        let repo = UserRepository()
        self.viewModel = ProfileViewModel(repo: repo)
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBarTitle()
        setupProfilePicture()
        viewModel.delegate = self
        viewModel.fetchInfosFromFirestore()
        
        ActivityIndicatorHelper.shared.start()
    }
    
    @IBAction func logoutBarButtonItem_TUI(_ sender: UIBarButtonItem) {
        signOutAlert()
    }
    
    @IBAction func uploadPhotoButton_TUI(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true)
        }
    }
    
    func setupProfilePicture() {
        imagePicker.delegate = self
        profilePictureImage.layer.cornerRadius = profilePictureImage.frame.size.height / 2
        profilePictureImage.layer.masksToBounds = true
        profilePictureImage.contentMode = .scaleAspectFill
        
        viewModel.fetchProfilePhotoFromFirebase()
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
        ActivityIndicatorHelper.shared.stop()
    }
    
    func logoutSuccess() {
        DispatchQueue.main.async {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "navigationController") as? UINavigationController

            if let sceneDelegate = UIApplication.shared.connectedScenes
                .first(where: { $0.delegate is SceneDelegate })?.delegate as? SceneDelegate,
                let window = sceneDelegate.window {
                
                UIView.transition(with: window, duration: 0.5, options: .transitionCurlUp, animations: {
                    window.rootViewController = vc
                }, completion: nil)
            }
        }
    }

    func logoutFailure(errorMessage: String) {
        MakeAlert.alertMessage(title: "Error", message: errorMessage, style: .alert, vc: self)
    }
    
    func profilePhotoUpdated(imageData: Data) {
        DispatchQueue.main.async {
            self.profilePictureImage.image = UIImage(data: imageData) ?? UIImage(systemName: "person.circle")
            ActivityIndicatorHelper.shared.stop()
            print("pp updated")
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            viewModel.selectedProfileImage = pickedImage
//            profilePictureImage.image = viewModel.selectedProfileImage
            dismiss(animated: true)
            ActivityIndicatorHelper.shared.start()
        }
    }
}

extension ProfileViewController: UINavigationControllerDelegate {
    // this extension should be for imagepicker
}
