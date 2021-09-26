//
//  UserProfilePresenter.swift
//  Aviato
//
//  Created by Vlad on 11.07.2021.
//

import Foundation
import UIKit

protocol IUserProfilePresenter {
    func logout()
    func getUser(userViewController: IUserProfileViewController)
    func editUser(view: IUserProfileViewController)
    func getImage(path: String) -> UIImage?
    
}

class UserProfilePresenter: IUserProfilePresenter {

    let userID: String
    let storageManager = StorageManager()
    
    init(userID: String) {
        self.userID = userID
    }
    
    func getUser(userViewController: IUserProfileViewController) {
        let user = storageManager.loadUser(username: nil, userID: userID)
        userViewController.showUserInfo(userInfo: user ?? UserViewModel(userID: "", username: "", password: "", birthDate: Date(), email: "", name: "", avatarPath: ""))
        
    }
    
    func logout() {
        storageManager.deleteUser(userID: userID)
        FirebaseManager.logout()
        KeyChainManager.deleteUserSession()
        AppDelegate.shared.rootViewController.switchToLogout()
    }
    
    
    func editUser(view: IUserProfileViewController) {
        let presenter: IEditUserProfilePresenter = EditUserProfilePresenter(userID: self.userID)
        let viewController: EditUserProfileViewController = EditUserProfileViewController(editPresenter: presenter)
        view.showEditUserProfileScreen(view: viewController)
    }
    
    func getImage(path: String) -> UIImage? {
        return storageManager.loadImage(path: path)
    }
    
}
