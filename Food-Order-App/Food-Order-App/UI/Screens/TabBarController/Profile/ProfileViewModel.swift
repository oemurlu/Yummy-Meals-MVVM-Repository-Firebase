//
//  ProfileViewModel.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 18.12.2023.
//

import Foundation
import UIKit

protocol ProfileViewModelDelegate: AnyObject {
    func infosDidLoad(username: String, fullName: String, email: String, phoneNumber: String)
    func logoutSuccess()
    func logoutFailure(errorMessage: String)
    func profilePhotoUpdated(imageData: Data)
}

class ProfileViewModel {
    
    private let repo: UserRepository
    weak var delegate: ProfileViewModelDelegate?
    weak var selectedProfileImage: UIImage? {
        didSet {
            uploadProfilePhotoToFirebase()
        }
    }
    
    
    init(repo: UserRepository) {
        self.repo = repo
    }
    
    func fetchInfosFromFirestore() {
        repo.fetchUserInfosFromFirestore { username, fullName, email, phoneNumber in
            self.delegate?.infosDidLoad(username: username, fullName: fullName, email: email, phoneNumber: phoneNumber)
        }
    }
    
    func logout() {
        repo.logout {
            self.delegate?.logoutSuccess()
        } onError: { error in
            self.delegate?.logoutFailure(errorMessage: error)
        }
    }
    
    func uploadProfilePhotoToFirebase() {
        if let image = selectedProfileImage {
            repo.uploadProfilePhotoToFirebase(image: image)
        }
    }
    
    func fetchProfilePhotoFromFirebase() {
        repo.fetchProfilePhotoFromFirebase { imageData in
            self.delegate?.profilePhotoUpdated(imageData: imageData)
        }
    }
}
